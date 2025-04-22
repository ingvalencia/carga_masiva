<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ExcelController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::post('/upload-excel', [ExcelController::class, 'upload']);

Route::post('/login', function (Request $request) {
    $credentials = $request->validate([
        'email' => 'required|email',
        'password' => 'required'
    ]);

    if (Auth::attempt($credentials)) {
        return response()->json([
            'token' => Auth::user()->createToken('API_TOKEN')->plainTextToken
        ]);
    }

    return response()->json(['error' => 'Credenciales inválidas'], 401);
})->name('login');


Route::get('/ruta-solo-admin', function () {
    return response()->json(['message' => 'Solo admin puede ver esto']);
})->middleware('auth:sanctum', 'is_admin');

Route::get('/personas', function (Request $request) {
    $offset = $request->query('offset', 0);
    $personas = DB::select('SELECT * FROM personas LIMIT 100 OFFSET ?', [$offset]);
    return response()->json(['personas' => $personas]);
});

Route::get('/personas/{id}/detalles', function ($id) {
    $telefonos = DB::select('SELECT * FROM telefonos WHERE persona_id = ?', [$id]);
    $direcciones = DB::select('SELECT * FROM direcciones WHERE persona_id = ?', [$id]);
    return response()->json([
        'telefonos' => $telefonos,
        'direcciones' => $direcciones
    ]);
});
