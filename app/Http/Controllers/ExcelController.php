<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use PDO;

class ExcelController extends Controller
{
    public function upload(Request $request) {

        try {
            DB::connection()->getPdo();
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error de conexión a DB: ' . $e->getMessage()
            ], 500);
        }

        try {
            $request->validate([
                'file' => [
                    'required',
                    'file',
                    function ($attribute, $value, $fail) {
                        $extension = $value->getClientOriginalExtension();
                        if (!in_array(strtolower($extension), ['xlsx', 'csv'])) {
                            $fail('El archivo debe ser de tipo: xlsx, csv.');
                        }
                    },
                    'max:2048'
                ]
            ]);

            $file = $request->file('file');
            $filePath = $file->getRealPath();


            if (strtolower($file->getClientOriginalExtension()) === 'xlsx') {
                $csvPath = $this->convertExcelToCsv($filePath);
                $filePath = $csvPath;
            }

            $affectedRows = DB::connection()->getPdo()->exec(
                "LOAD DATA LOCAL INFILE '".str_replace('\\', '/', addslashes($filePath))."'
                 INTO TABLE temp_excel_data
                 FIELDS TERMINATED BY ','
                 ENCLOSED BY '\"'
                 LINES TERMINATED BY '\n'
                 IGNORE 1 ROWS
                 (nombre, paterno, materno, telefono, calle, numero_exterior, numero_interior, colonia, cp)"
            );

            return response()->json([
                'success' => true,
                'message' => 'Archivo procesado exitosamente',
                'rows_affected' => $affectedRows
            ]);

        } catch (\Exception $e) {
            \Log::error('Error al procesar archivo: '.$e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Error al procesar el archivo: '.$e->getMessage()
            ], 500);
        }
    }
}
