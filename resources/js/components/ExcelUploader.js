import React, { useCallback, useState } from 'react';
import { useDropzone } from 'react-dropzone';

function ExcelUploader() {
  const [file, setFile] = useState(null);
  const [uploadStatus, setUploadStatus] = useState('');

  const onDrop = useCallback((acceptedFiles) => {
    const selectedFile = acceptedFiles[0];
    if (!selectedFile?.name.match(/\.(xlsx|csv)$/)) {
      alert('Solo archivos Excel (.xlsx o .csv)');
      return;
    }
    setFile(selectedFile);
    uploadFile(selectedFile);
  }, []);

  const uploadFile = async (fileToUpload) => {
    const formData = new FormData();
    formData.append('file', fileToUpload);

    setUploadStatus('Enviando archivo...');

    try {
      const response = await fetch('http://localhost:8000/api/upload-excel', {
        method: 'POST',
        body: formData,
        headers: {
            'Accept': 'application/json', 
        },
      });

      const data = await response.json();

      if (response.ok) {
        setUploadStatus('✓ Archivo subido correctamente');
        console.log('Respuesta del servidor:', data);
      } else {
        setUploadStatus('Error al subir el archivo');
        console.error('Error del servidor:', data);
      }
    } catch (error) {
      setUploadStatus('✗ Error de conexión');
      console.error('Error de red:', error);
    }
  };

  const { getRootProps, getInputProps, isDragActive } = useDropzone({
    onDrop,
    accept: {
      'application/vnd.ms-excel': ['.xlsx'],
      'text/csv': ['.csv']
    },
    maxFiles: 1
  });

  return (
    <div className="container mt-5">
      <h2>Cargar Excel</h2>
      <div {...getRootProps()}
           className={`dropzone ${isDragActive ? 'active' : ''}`}
           style={{
             border: '2px dashed #ccc',
             borderRadius: '4px',
             padding: '20px',
             textAlign: 'center',
             cursor: 'pointer',
             marginBottom: '20px'
           }}>
        <input {...getInputProps()} />
        {
          isDragActive ?
            <p>Suelta el archivo Excel aquí...</p> :
            <p>Arrastra y suelta tu archivo Excel aquí, o haz clic para seleccionarlo</p>
        }
      </div>

      {file && (
        <div>
          <p>Archivo seleccionado: {file.name}</p>
          <p>Estado: {uploadStatus}</p>
        </div>
      )}
    </div>
  );
}

export default ExcelUploader;
