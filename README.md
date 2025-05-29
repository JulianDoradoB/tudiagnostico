TuDiagnostico: Diagnóstico Inteligente de Lesiones Cutáneas
TuDiagnostico es una aplicación móvil desarrollada con Flutter que permite el diagnóstico automático de lesiones cutáneas a partir de imágenes. La aplicación se integra con una API robusta construida con FastAPI en Python, la cual utiliza un modelo de aprendizaje profundo preentrenado para la clasificación de lesiones.

📱 Características Principales
Captura de Imágenes: Permite a los usuarios tomar fotos de lesiones directamente desde la cámara de su dispositivo.
Clasificación Automática con IA: Utiliza inteligencia artificial para clasificar automáticamente el tipo de lesión cutánea a partir de la imagen proporcionada.
Descripciones Médicas Detalladas: Ofrece descripciones médicas exhaustivas para cada tipo de lesión diagnosticada, brindando información valiosa al usuario.
Interfaz de Usuario Moderna: Presenta una interfaz de usuario atractiva y moderna, mejorada con el uso de fuentes de Google y gráficos SVG.
Almacenamiento Local Robusto: Gestiona el almacenamiento de datos de forma local utilizando SQLite, asegurando la persistencia de la información.
Manejo de Estado Eficiente: Implementa una gestión de estado optimizada mediante el uso de Provider y Get, garantizando una experiencia de usuario fluida y reactiva.

🧠 Tecnologías Utilizadas
🔧 Flutter
Versión SDK: ^3.7.2

Dependencias Clave:

flutter_dotenv: ^5.2.1
http: ^1.3.0
cupertino_icons: ^1.0.8
get: ^4.7.2
image_picker: ^1.1.2
google_fonts: ^6.2.1
path_provider: ^2.1.5
flutter_svg: ^2.1.0
sqflite: ^2.4.2
path: ^1.9.1
appwrite: ^15.0.0
camera: ^0.11.1
dio: ^5.0.0
image: ^4.0.15
intl: ^0.19.0
uuid: ^4.0.0
provider: ^6.0.0
Dependencias de Desarrollo:

flutter_test
flutter_lints: ^5.0.0
Overrides de Dependencias:

YAML

dependency_overrides:
  flutter_web_auth_2: ^4.1.0

☁️ Configuración de Appwrite
Appwrite se utiliza para la gestión de usuarios y la base de datos en la nube. Asegúrate de configurar tus credenciales de Appwrite en el código de tu aplicación Flutter.

Dart

class AppwriteConstants {
  static const String endpoint = 'https://fra.cloud.appwrite.io/v1';
  static const String projectId = '681bd1fb0002d39bc1ed';
  static const String databaseId = '681bd420001f5ae3cd26';
  static const String usersCollectionId = '681bd428003651552707';
}

DATOS A TENER ENCUENTA ⚠️IMPORTANTE⚠️

DESCARGAR EL ARCHIVO LESIONES_API QUE ESTA ADJUNTADO EN EL BLOC DE NOTAS LINK DEL GIT 

🧪 Configuración del Backend (API de Lesiones)
La funcionalidad central de diagnóstico reside en la API de FastAPI, que interactúa con un modelo de aprendizaje profundo para clasificar las imágenes.

🔸 Requisitos Previos
Para que la aplicación funcione correctamente, es crucial que la API de lesiones (lesion_api.py) esté ejecutándose. Este archivo Python contiene la lógica para realizar el diagnóstico y carga el dataset necesario para el modelo.

Código de la API (lesion_api.py)
Python

from fastapi import FastAPI, File, UploadFile
from transformers import BeitForImageClassification, BeitImageProcessor
from PIL import Image
import torch
import io

app = FastAPI()

# Carga del modelo y el procesador preentrenados
model = BeitForImageClassification.from_pretrained(
    "ALM-AHME/beit-large-patch16-224-finetuned-Lesion-Classification-HAM10000-AH-60-20-20"
)
processor = BeitImageProcessor.from_pretrained(
    "ALM-AHME/beit-large-patch16-224-finetuned-Lesion-Classification-HAM10000-AH-60-20-20"
)

@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    """
    Endpoint para clasificar lesiones cutáneas a partir de una imagen.
    """
    image_bytes = await file.read()
    image = Image.open(io.BytesIO(image_bytes)).convert("RGB")
    inputs = processor(images=image, return_tensors="pt")
    outputs = model(**inputs)
    logits = outputs.logits
    predicted_class_idx = logits.argmax(-1).item()
    predicted_label = model.config.id2label[predicted_class_idx]

    # Diccionario de descripciones detalladas por tipo de lesión
    descripciones = {
        "bcc": "Carcinoma basocelular: un tipo de cáncer de piel de crecimiento lento que a menudo aparece como un bulto brillante o una llaga que no cicatriza.",
        "nv": "Nevus melanocítico: también conocido como lunar común. Son crecimientos en la piel que varían en color y forma.",
        "mel": "Melanoma: tipo de cáncer de piel más grave. A menudo se desarrolla a partir de lunares existentes o aparece como una nueva mancha oscura e irregular.",
        "akiec": "Queratosis actínica: parches ásperos y escamosos en la piel causados por la exposición al sol. Pueden ser precursores de cáncer de piel.",
        "df": "Dermatofibroma: un bulto pequeño, firme y benigno en la piel, a menudo de color marrón o rojizo, que puede picar o ser sensible.",
        "vasc": "Lesión vascular: incluyen angiomas, hemangiomas y otras malformaciones vasculares que aparecen como marcas rojas o púrpuras en la piel.",
        "bkl": "Léntigo solar: también conocido como 'manchas de la edad' o 'manchas hepáticas'. Son manchas planas y oscuras en la piel causadas por la exposición al sol.",
    }

    # Obtener descripción correspondiente, si no se encuentra, usa una por defecto
    descripcion = descripciones.get(predicted_label.lower(), "Descripción no disponible para esta lesión.")

    return {
        "diagnosis": predicted_label,
        "description": descripcion
    }

▶️ Cómo Ejecutar la API
Asegúrate de tener Python instalado (versión 3.10 o superior recomendada).

Instala las dependencias necesarias ejecutando el siguiente comando en tu terminal:

Bash

pip install fastapi uvicorn transformers pillow torch
Guarda el código de la API anterior en un archivo llamado lesion_api.py.

Inicia el servidor ejecutando el siguiente comando desde la terminal en el directorio donde guardaste lesion_api.py:

Bash

uvicorn lesion_api:app --reload
El parámetro --reload es útil durante el desarrollo, ya que reinicia el servidor automáticamente cuando detecta cambios en el código.

✅ Requisitos para que todo el proyecto funcione
Para asegurar que TuDiagnostico funcione sin problemas, verifica que cumples con los siguientes requisitos:

Elemento	Necesario
Flutter SDK 3.7.2	✅
Python 3.10 o superior	✅
Appwrite Project ID	✅
FastAPI API ejecutándose	✅
Archivo .env configurado	✅
Acceso a Internet	✅

Export to Sheets
📝 Notas Finales
Este proyecto es una demostración completa de cómo se pueden integrar las tecnologías modernas como Flutter para el desarrollo móvil, un backend robusto con Python y FastAPI, y capacidades de Inteligencia Artificial para la clasificación de imágenes. El resultado es una aplicación amigable y eficiente que proporciona diagnósticos automáticos de lesiones cutáneas.

