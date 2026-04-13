<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Filetoprint extends Model
{
    public function printRequests()
    {
        return $this->hasMany(PrintRequest::class, 'filetoprint_id')->latest();
    }

    public function latestPrintRequest()
    {
        return $this->hasOne(PrintRequest::class, 'filetoprint_id')->latestOfMany();
    }

    protected $guarded = [];
    
    protected $appends = ['type', 'url', 'status'];

    public function getTypeAttribute()
    {
        $extension = pathinfo($this->original_name, PATHINFO_EXTENSION);
        return strtoupper($extension) ?: 'FILE';
    }

    public function getUrlAttribute()
    {
        return asset('storage/' . ltrim($this->filename, '/'));
    }

    public function getStatusAttribute()
    {
        return $this->latestPrintRequest ? $this->latestPrintRequest->status : 'new';
    }
}
