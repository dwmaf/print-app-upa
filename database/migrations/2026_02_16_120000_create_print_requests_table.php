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
        Schema::create('print_requests', function (Blueprint $table) {
            $table->id();
            $table->string('request_id')->unique(); // Unique Order ID
            $table->foreignId('filetoprint_id')->nullable()->constrained('filetoprints')->nullOnDelete(); // The file to print
            $table->string('original_name'); // Snapshot of filename just in case
            $table->string('status')->default('pending'); // pending, verified, rejected, printed
            $table->integer('copies')->default(1);
            $table->string('color_mode')->default('bw');
            $table->string('paper_size')->default('A4');
            $table->string('page_range')->default('all');
            $table->integer('detected_pages')->default(1);
            $table->integer('calculated_pages')->default(1);
            $table->timestamp('verified_at')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('print_requests');
    }
};
