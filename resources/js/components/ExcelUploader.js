import React, { useCallback, useState } from 'react';
import { useDropzone } from 'react-dropzone'; 

function ExcelUploader() {
  const [file, setFile] = useState(null);

  const onDrop = useCallback((acceptedFiles) => {
    const selectedFile = acceptedFiles[0];
    if (!selectedFile?.name.match(/\.(xlsx|csv)$/)) {
      alert('Solo archivos Excel (.xlsx o .csv)');
      return;
    }
    setFile(selectedFile);
    console.log('Archivo válido:', selectedFile.name);
  }, []);

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
             cursor: 'pointer'
           }}>
        <input {...getInputProps()} />
        {
          isDragActive ?
            <p>Suelta el archivo Excel aquí...</p> :
            <p>Arrastra y suelta tu archivo Excel aquí, o haz clic para seleccionarlo</p>
        }
        {file && <p>Archivo seleccionado: {file.name}</p>}
      </div>
    </div>
  );
}

export default ExcelUploader;
