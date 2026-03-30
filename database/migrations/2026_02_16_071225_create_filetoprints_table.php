<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('filetoprints', function (Blueprint $table) {
            $table->id();
            $table->string('filename'); // nama file random yg kesimpan di storage
            $table->foreignId('station_id')->nullable()->constrained('users'); // ID User laptop station
            $table->string('original_name'); // nama file asli yang muncul di ui
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('files');
    }
};
