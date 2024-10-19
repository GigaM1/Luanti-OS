import subprocess
import platform
import re
def obtener_modelo_gpu_y_directx():
    sistema = platform.system()
    
    try:
        if sistema == "Windows":
            # Ejecutar dxdiag y guardar la salida en un archivo
            subprocess.run(["dxdiag", "/t", "dxdiag_output.txt"], capture_output=True, text=True)
            with open("dxdiag_output.txt", "r") as archivo:
                contenido = archivo.read()
                # Buscar el modelo de GPU
                gpu_model = re.search(r"Card name:\s*(.*)", contenido)
                # Buscar la versión de DirectX
                directx_version = re.search(r"DirectX Version:\s*(.*)", contenido)

                

                if gpu_model:
                    return gpu_model.group(1).strip(), directx_version.group(1).strip() if directx_version else "No se encontró versión de DirectX."
                else:
                    return "No se encontró ninguna GPU.", "No se encontró versión de DirectX."
        else:
            return "Sistema operativo no soportado.", "Sistema operativo no soportado."

    except Exception as e:
        return f"Ocurrió un error: {e}", "Ocurrió un error."

def obtener_informacion_sistema():
    # Obtener información del sistema
    sistema_operativo = platform.system()

    # Obtener información del procesador
    procesador = platform.processor()
    
    # Obtener arquitectura
    arquitectura = platform.architecture()[0]
    
    # Obtener modelo de Windows
    modelo_windows = platform.version()
    
    return procesador, arquitectura, modelo_windows, sistema_operativo

def escribir_informacion_en_archivo():
    modelo_gpu, version_directx = obtener_modelo_gpu_y_directx()
    procesador, arquitectura, modelo_windows, sistema_operativo = obtener_informacion_sistema()
    
    # Escribir la información en un archivo de texto
    with open("information.txt", "w") as archivo:
        archivo.write(f"Modelo de GPU: {modelo_gpu}\n")
        archivo.write(f"Versión de DirectX: {version_directx}\n")
        archivo.write(f"Procesador: {procesador}\n")
        archivo.write(f"Arquitectura: {arquitectura}\n")
        archivo.write(f"Modelo de Windows: {modelo_windows}\n")
        archivo.write(f"operative System: {sistema_operativo}\n")

if __name__ == "__main__":
    escribir_informacion_en_archivo()