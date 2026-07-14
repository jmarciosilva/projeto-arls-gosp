<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->foreignId('lodge_id')->nullable()->after('id')->constrained()->nullOnDelete();
            $table->foreignId('member_id')->nullable()->after('lodge_id')->constrained()->nullOnDelete();
            $table->string('whatsapp')->nullable()->after('email');
            $table->string('role')->default('lodge_admin')->after('whatsapp');
            $table->softDeletes();
        });
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropConstrainedForeignId('lodge_id');
            $table->dropConstrainedForeignId('member_id');
            $table->dropColumn(['whatsapp', 'role']);
            $table->dropSoftDeletes();
        });
    }
};
