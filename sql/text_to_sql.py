import os
import sys
from dotenv import load_dotenv

# 1. Cargar las variables de entorno del archivo .env
load_dotenv()
API_KEY = os.getenv("LLM_API_KEY")

if not API_KEY:
    raise ValueError("Error: No se encontró la variable LLM_API_KEY en el archivo .env")

# Intentamos importar la nueva librería recomendada por Google 'google-genai'
try:
    from google import genai
    from google.genai import types
    USAR_NUEVA_API = True
except ImportError:
    import google.generativeai as genai
    USAR_NUEVA_API = False

# DEFINICIÓN DEL SYSTEM PROMPT (Esquema de la biblioteca BiblioIA)
SYSTEM_PROMPT = """
Eres un asistente experto en bases de datos relacionales y traducción de lenguaje natural a SQL.
Tu única tarea es transformar preguntas en español a consultas SQL válidas para un motor MySQL 8+.

CONTEXTO DEL ESQUEMA DE LA BASE DE DATOS:
A continuación se detalla la estructura exacta de las tablas de la biblioteca "BiblioIA":

1. TABLA: AUTOR
   - id_autor (INT, PK, AUTO_INCREMENT)
   - nombre (VARCHAR)
   - apellido (VARCHAR)
   - nacionalidad (VARCHAR)

2. TABLA: GENERO
   - id_genero (INT, PK, AUTO_INCREMENT)
   - nombre (VARCHAR)
   - descripcion (TEXT)

3. TABLA: LIBRO
   - isbn (VARCHAR, PK)
   - titulo (VARCHAR)
   - anio_publicacion (INT)
   - stock_total (INT)
   - stock_disponible (INT)

4. TABLA: LIBRO_AUTOR (Relación N:M)
   - isbn (VARCHAR, FK -> LIBRO.isbn)
   - id_autor (INT, FK -> AUTOR.id_autor)
   PRIMARY KEY (isbn, id_autor)

5. TABLA: LIBRO_GENERO (Relación N:M)
   - isbn (VARCHAR, FK -> LIBRO.isbn)
   - id_genero (INT, FK -> GENERO.id_genero)
   PRIMARY KEY (isbn, id_genero)

6. TABLA: EJEMPLAR
   - id_ejemplar (INT, PK, AUTO_INCREMENT)
   - isbn (VARCHAR, FK -> LIBRO.isbn)
   - nro_ejemplar (INT)
   - estado_fisico (VARCHAR)

7. TABLA: SOCIO
   - id_socio (INT, PK, AUTO_INCREMENT)
   - dni (VARCHAR, UNIQUE)
   - nombre (VARCHAR)
   - apellido (VARCHAR)
   - email (VARCHAR, UNIQUE)
   - fecha_alta (DATE)
   - estado (VARCHAR)

8. TABLA: PRESTAMO
   - id_prestamo (INT, PK, AUTO_INCREMENT)
   - id_socio (INT, FK -> SOCIO.id_socio)
   - id_ejemplar (INT, FK -> EJEMPLAR.id_ejemplar)
   - fecha_prestamo (DATE)
   - fecha_vencimiento (DATE)
   - fecha_devolucion (DATE, NULL si no se devolvió)
   - estado (VARCHAR)

9. TABLA: SANCION
   - id_sancion (INT, PK, AUTO_INCREMENT)
   - id_socio (INT, FK -> SOCIO.id_socio)
   - tipo (VARCHAR)
   - fecha_inicio (DATE)
   - fecha_fin (DATE)
   - motivo (TEXT)

REGLAS CRÍTICAS DE SALIDA:
- Responde ÚNICAMENTE con el código SQL puro y válido.
- NO incluyas introducciones, explicaciones, comentarios, ni bloques de formato markdown (NO uses ```sql ... ```).
- Si la pregunta no se puede responder con el esquema provisto, devuelve únicamente el texto: ERROR_ESQUEMA.

EJEMPLOS DE REFERENCIA (FEW-SHOT PROMPTING):

Pregunta: ¿Cuáles son los 5 libros más prestados este año?
Respuesta: SELECT l.titulo, COUNT(p.id_prestamo) AS total_prestamos FROM PRESTAMO p JOIN EJEMPLAR e ON p.id_ejemplar = e.id_ejemplar JOIN LIBRO l ON e.isbn = l.isbn WHERE YEAR(p.fecha_prestamo) = YEAR(CURDATE()) GROUP BY l.isbn, l.titulo ORDER BY total_prestamos DESC LIMIT 5;

Pregunta: ¿Qué socios tienen préstamos vencidos en este momento?
Respuesta: SELECT DISTINCT s.id_socio, s.nombre, s.apellido, s.dni FROM SOCIO s JOIN PRESTAMO p ON s.id_socio = p.id_socio WHERE p.estado = 'VENCIDO' OR (p.fecha_vencimiento < CURDATE() AND p.fecha_devolucion IS NULL);
"""

def text_to_sql(pregunta: str) -> str:
    """
    Recibe una pregunta en lenguaje natural y utiliza la API de Gemini
    para traducirla a código SQL limpio y ejecutable en MySQL.
    """
    MODELO_RECOMENDADO = "gemini-2.5-flash"

    try:
        if USAR_NUEVA_API:
            client = genai.Client(api_key=API_KEY)
            response = client.models.generate_content(
                model=MODELO_RECOMENDADO,
                contents=pregunta,
                config=types.GenerateContentConfig(
                    system_instruction=SYSTEM_PROMPT,
                    temperature=0.0,
                    max_output_tokens=300
                )
            )
            sql_query = response.text.strip()
        else:
            import warnings
            with warnings.catch_warnings():
                warnings.simplefilter("ignore")
                genai.configure(api_key=API_KEY)
                model = genai.GenerativeModel(
                    model_name=MODELO_RECOMENDADO,
                    system_instruction=SYSTEM_PROMPT
                )
                config = genai.types.GenerationConfig(
                    temperature=0.0,
                    max_output_tokens=300
                )
                response = model.generate_content(pregunta, generation_config=config)
                sql_query = response.text.strip()

        # Sanitización de bloques Markdown
        if sql_query.startswith("```sql"):
            sql_query = sql_query.replace("```sql", "").replace("```", "").strip()
        elif sql_query.startswith("```"):
            sql_query = sql_query.replace("```", "").strip()

        return sql_query

    except Exception as e:
        print(f"\n[ERROR EN LA API DE GEMINI]")
        print(f"Detalle del error: {e}")
        raise e

# ==========================================
# MÓDULO INTERACTIVO DE USUARIO
# ==========================================
if __name__ == "__main__":
    # Limpiamos consola según el sistema operativo para mejor experiencia visual
    os.system('cls' if os.name == 'nt' else 'clear')
    
    print("\033[96m" + "="*65 + "\033[0m")
    print(" 🤖 AGENTE INTELIGENTE BIBLIOIA: CONVERSOR TEXT-TO-SQL ".center(65))
    print("\033[96m" + "="*65 + "\033[0m")
    print("Escribe cualquier pregunta en español sobre la biblioteca.")
    print("El Agente generará el código SQL óptimo para MySQL.")
    print("Para salir del programa, escribe '\033[91msalir\033[0m' o '\033[91mq\033[0m'.")
    print("\033[96m" + "-"*65 + "\033[0m")

    while True:
        try:
            # Capturar la consulta del usuario
            pregunta_usuario = input("\n\033[95mPregunta >> \033[0m").strip()
            
            # Condición de salida
            if pregunta_usuario.lower() in ['salir', 'exit', 'q', 'quit']:
                print("\n\033[92m¡Gracias por usar BiblioIA!\033[0m\n")
                break
                
            # Si el usuario presionó enter sin escribir nada
            if not pregunta_usuario:
                continue
                
            print("\033[90mProcesando esquema y traduciendo con Gemini...\033[0m", end="\r")
            
            # Llamar a tu función IA
            sql_generado = text_to_sql(pregunta_usuario)
            
            # Imprimir resultado con diseño premium
            print(" " * 60, end="\r") # Limpiar la línea de "Procesando..."
            print("\033[92m[¡ÉXITO!] SQL Generado:\033[0m")
            print(f"\033[94m{sql_generado}\033[0m")
            print("\033[90m" + "-"*40 + "\033[0m")
            
        except KeyboardInterrupt:
            print("\n\n\033[91mPrograma interrumpido por el usuario. Saliendo...\033[0m\n")
            break
        except Exception as e:
            print(" " * 60, end="\r")
            print(f"\033[91mError al procesar la consulta:\033[0m {e}")