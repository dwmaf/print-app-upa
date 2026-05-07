<script setup>
import { Check, X } from 'lucide-vue-next';

defineProps({
    show: Boolean,
    action: {
        type: String,
        default: 'verify' // 'verify' or 'reject'
    },
    requestId: String,
    loading: Boolean
});

defineEmits(['close', 'confirm']);
</script>

<template>
    <div v-if="show" class="fixed inset-0 z-[60] flex items-center justify-center bg-black/50 backdrop-blur-sm">
        <div class="bg-white rounded-2xl p-8 w-96 text-center shadow-xl">
            <!-- Icon -->
            <div v-if="action === 'verify'"
                class="w-16 h-16 bg-green-50 text-green-600 rounded-full flex items-center justify-center mx-auto mb-4">
                <Check class="w-8 h-8" stroke-width="2.5" />
            </div>
            <div v-else
                class="w-16 h-16 bg-red-50 text-red-600 rounded-full flex items-center justify-center mx-auto mb-4">
                <X class="w-8 h-8" stroke-width="2.5" />
            </div>

            <!-- Title -->
            <h3 class="text-xl font-bold text-gray-900 mb-2">
                {{ action === 'verify' ? 'Verifikasi Order?' : 'Tolak Order?' }}
            </h3>

            <!-- Message -->
            <p class="text-gray-500 mb-6">
                {{ action === 'verify' 
                    ? 'Order ini akan diverifikasi dan siap untuk dicetak.' 
                    : 'Order ini akan ditolak dan tidak dapat dicetak.' }}
            </p>

            <!-- Request ID -->
            <div class="bg-gray-50 p-3 rounded-lg mb-6">
                <p class="text-xs text-gray-400 font-bold mb-1">KODE REQUEST</p>
                <p class="text-sm font-black text-gray-700 font-mono">{{ requestId }}</p>
            </div>

            <!-- Buttons -->
            <div class="flex gap-3">
                <button @click="$emit('close')" :disabled="loading"
                    class="flex-1 py-3 bg-gray-100 hover:bg-gray-200 disabled:opacity-50 disabled:cursor-not-allowed rounded-xl font-bold text-gray-700 transition">
                    Batal
                </button>
                <button @click="$emit('confirm')" :disabled="loading"
                    :class="[
                        'flex-1 py-3 rounded-xl font-bold text-white transition disabled:opacity-50 disabled:cursor-not-allowed',
                        action === 'verify' 
                            ? 'bg-green-600 hover:bg-green-700 shadow-lg shadow-green-200'
                            : 'bg-red-600 hover:bg-red-700 shadow-lg shadow-red-200'
                    ]">
                    {{ loading ? 'Proses...' : (action === 'verify' ? 'Verifikasi' : 'Tolak') }}
                </button>
            </div>
        </div>
    </div>
</template>
