import os
import pandas as pd
import mysql.connector
from mysql.connector import Error
from dotenv import load_dotenv

load_dotenv(dotenv_path='C:\\Users\\sofit\\BiblioIA\\.env')

def consultar_base_de_datos(consulta_sql):
    """
    Ejecuta una consulta SQL segura y la devuelve como un DataFrame de Pandas limpio.
    """
    # --- BARRERA DE SEGURIDAD (Lista Blanca) ---
    consulta_limpia = consulta_sql.strip().upper()
    if not consulta_limpia.startswith("SELECT"):
        mensaje_error = "Error de Seguridad: Operación denegada. El sistema es de solo lectura y solo permite sentencias 'SELECT'."
        return None, mensaje_error

    conexion = None  # ✅ CORREGIDO: Era "conexion = None," (con coma)
    try:
        # 1. Establecer la conexión con MySQL
        conexion = mysql.connector.connect(
            host=os.getenv("DB_HOST"),
            port=int(os.getenv("DB_PORT", 3306)), # Forzamos a entero por si acaso
            database=os.getenv("DB_NAME"),
            user=os.getenv("DB_USER"),
            password=os.getenv("DB_PASSWORD")
        )

        if conexion.is_connected():
            # 2. Ejecutar la consulta con Pandas (suprimiendo warnings de consola)
            import warnings
            with warnings.catch_warnings():
                warnings.simplefilter('ignore', UserWarning)
                df_resultado = pd.read_sql(consulta_sql, conexion)
            
            # --- 3. LIMPIEZA VISUAL CON PANDAS ---
            
            # A. Manejo de tablas vacías
            if df_resultado.empty:
                df_vacio = pd.DataFrame({'Resultado': ['La consulta es válida, pero no hay datos que coincidan.']})
                return df_vacio, None
            
            # B. Formateo de columnas (ej: "id_prestamo" -> "Id Prestamo")
            nuevas_columnas = {col: col.replace('_', ' ').title() for col in df_resultado.columns}
            df_resultado.rename(columns=nuevas_columnas, inplace=True)
            
            # C. Limpiar fechas (sacar el 00:00:00 del final)
            for col in df_resultado.columns:
                # Chequeamos si la columna es de tipo datetime
                if pd.api.types.is_datetime64_any_dtype(df_resultado[col]):
                    df_resultado[col] = df_resultado[col].dt.strftime('%Y-%m-%d')
            
            # Todo salió perfecto, devolvemos la tabla pulida
            return df_resultado, None

    except Error as e:
        # 4. Atajar el error para que el sistema no se caiga y la IA pueda corregirlo
        mensaje_error = f"Error de sintaxis o ejecución en MySQL: {e}"
        return None, mensaje_error

    finally:
        # 5. Cerrar siempre la puerta al salir
        if conexion is not None and conexion.is_connected():
            conexion.close()

# Esto queda comentado porque son pruebas de conexión, si quieren prueben en su compu. Descarguen el 
#archivo .env con su contraseña de MySQL
""""  
if __name__ == '__main__':
    print("Iniciando pruebas de conexión...\n")
    
    print("--- PRUEBA 1: Consulta Válida ---")
    # Buscamos en una tabla que existe. Como no le cargamos datos, 
    # debería saltar tu validación de Pandas de "tabla vacía".
    df_ok, error_ok = consultar_base_de_datos("SELECT * FROM LIBRO;")
    
    if error_ok:
        print("❌ Falló la conexión:", error_ok)
    else:
        print("✅ ¡Éxito! La base respondió:")
        print(df_ok)
        
    print("\n--- PRUEBA 2: Consulta Inválida ---")
    # Pedimos una tabla que sabemos que no existe para ver si 
    # ataja el error de MySQL y lo devuelve limpio para la IA.
    df_mal, error_mal = consultar_base_de_datos("SELECT * FROM TABLA_QUE_NO_EXISTE;")
    
    if error_mal:
        print("✅ ¡Error atrapado con éxito! Mensaje listo para la IA:")
        print(error_mal)
    else:
        print("❌ Algo falló, esta consulta no debería haber funcionado.")
"""
print("\n--- PRUEBA 3: Intento de Inyección (Borrar tabla) ---")
df_hack, error_hack = consultar_base_de_datos("DROP TABLE LIBRO;")

if error_hack:
    print("✅ ¡Ataque bloqueado con éxito! Mensaje:")
    print(error_hack)
else:
    print("❌ PELIGRO: El sistema permitió una operación destructiva.")