<?php

use App\Http\Controllers\Admin\AuthController;
use App\Http\Controllers\Admin\LodgeController;
use App\Modules\Lodges\Livewire\RegisterLodgeWizard;
use Illuminate\Support\Facades\Route;

Route::get('/login', [AuthController::class, 'create'])->middleware('guest')->name('login');
Route::post('/login', [AuthController::class, 'store'])->middleware('guest')->name('login.store');
Route::post('/logout', [AuthController::class, 'destroy'])->middleware('auth')->name('logout');

Route::middleware(['auth', 'platform_admin'])->group(function () {
    Route::get('/lojas', [LodgeController::class, 'index'])->name('lodges.index');
    Route::get('/lojas/criar', RegisterLodgeWizard::class)->name('lodges.create');
});
