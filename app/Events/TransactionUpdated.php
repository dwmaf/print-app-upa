<?php

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Contracts\Broadcasting\ShouldBroadcastNow;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class TransactionUpdated implements ShouldBroadcastNow
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public $stationId;

    public function __construct($stationId)
    {
        $this->stationId = $stationId;
    }

    public function broadcastOn(): array
    {
        return [
            new Channel('printing-channel.' . $this->stationId),
            new Channel('admin-upa-channel')
        ];
    }

    public function broadcastAs()
    {
        return 'transaction.updated';
    }
}