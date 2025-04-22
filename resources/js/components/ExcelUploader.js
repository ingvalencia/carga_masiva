import React from 'react';

function ExcelUploader() {
    const handleFileChange = (e) => {
        const file = e.target.files[0];
        if (!file?.name.match(/\.(xlsx|csv)$/)) {
            alert('Solo archivos Excel (.xlsx o .csv)');
            return;
        }
        console.log('Archivo válido:', file.name);
    };

    return (
        <div className="container mt-5">
            <h2>Cargar Excel</h2>
            <input
                type="file"
                onChange={handleFileChange}
                accept=".xlsx,.csv"
            />
        </div>
    );
}

export default ExcelUploader;
