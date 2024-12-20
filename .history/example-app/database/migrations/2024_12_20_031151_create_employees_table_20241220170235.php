<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('employees', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('department');
            $table->string('position');
            $table->string('email')->unique();
            $table->string('status');
            $table->decimal('salary', 10, 2);
            $table->date('hire_date');
            $table->string('contact_number');
            $table->text('address');
            $table->softDeletes();

            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('employees');
    }
};