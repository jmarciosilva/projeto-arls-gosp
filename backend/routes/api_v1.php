<?php

use App\Http\Controllers\Api\V1\AuthController;
use App\Http\Controllers\Api\V1\LodgeOptionsController;
use App\Modules\Lodges\Http\Controllers\Api\V1\LodgeController;
use App\Modules\Secretariat\Http\Controllers\Api\V1\LodgeSessionController;
use Illuminate\Support\Facades\Route;

Route::get('/lodge-options', LodgeOptionsController::class)->name('lodge-options');

Route::post('/login', [AuthController::class, 'login'])->name('login');

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout'])->name('logout');
    Route::get('/me', [AuthController::class, 'me'])->name('me');
    Route::get('/sessions', [LodgeSessionController::class, 'index'])->name('sessions.index');

    Route::middleware('platform_admin')->group(function () {
        Route::get('/lodges', [LodgeController::class, 'index'])->name('lodges.index');
        Route::post('/lodges', [LodgeController::class, 'store'])->name('lodges.store');
    });
});
