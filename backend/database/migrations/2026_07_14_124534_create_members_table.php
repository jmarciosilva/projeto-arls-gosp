<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('members', function (Blueprint $table) {
            $table->id();
            $table->foreignId('lodge_id')->constrained()->cascadeOnDelete();
            $table->string('status')->default('candidato');

            // Dados pessoais
            $table->string('name');
            $table->date('birth_date')->nullable();
            $table->string('natural_of', 2)->nullable();
            $table->string('marital_status')->nullable();
            $table->string('email')->nullable();
            $table->string('home_phone')->nullable();
            $table->string('mobile_phone')->nullable();
            $table->string('cpf')->nullable()->unique();
            $table->string('rg')->nullable();
            $table->string('blood_type')->nullable();

            // Profissão
            $table->string('occupation')->nullable();
            $table->string('workplace')->nullable();
            $table->string('work_phone')->nullable();

            // Endereço residencial
            $table->string('address_state', 2)->nullable();
            $table->string('address_city')->nullable();
            $table->string('address_street')->nullable();
            $table->string('address_number')->nullable();
            $table->string('address_complement')->nullable();
            $table->string('address_neighborhood')->nullable();
            $table->string('cep')->nullable();

            // Dados maçônicos
            $table->string('cim', 8)->nullable();
            $table->string('degree')->nullable();
            $table->string('position')->nullable();
            $table->date('admission_date')->nullable();
            $table->string('admission_type')->nullable();
            $table->text('observation')->nullable();

            $table->timestamps();
            $table->softDeletes();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('members');
    }
};
