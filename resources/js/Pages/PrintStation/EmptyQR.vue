<script setup>
import { Eye, EyeOff } from 'lucide-vue-next';

defineProps({
    qrCode: String,
    showQr: Boolean,
    stationName: String,
});

defineEmits(['toggleQr']);
</script>

<template>
    <div class="flex flex-col items-center">
        <!-- Logo & Title -->
        <div class="flex items-center gap-3 mb-8">
            <img src="/images/logo.png" class="w-16 h-16" alt="Logo">
            <h1 class="text-5xl font-koulen text-gray-900">Printation</h1>
        </div>

        <!-- User & Toggle -->
        <div class="flex flex-col items-center mb-6">
            <h2 class="uppercase font-medium text-gray-400">{{ stationName }}</h2>
            <button @click="$emit('toggleQr')"
                class="mt-3 flex items-center gap-2 text-xs font-bold text-indigo-600 hover:text-indigo-800 uppercase bg-indigo-50 hover:bg-indigo-100 px-4 py-2 rounded-full transition-all border border-indigo-100">
                <Eye v-if="!showQr" class="w-4 h-4" />
                <EyeOff v-else class="w-4 h-4" />
                {{ showQr ? 'Hide QR Card' : 'Show QR Card' }}
            </button>
        </div>

        <!-- QR Card -->
        <div v-if="showQr"
            class="w-fit bg-white p-8 rounded-2xl shadow-xl flex flex-col items-center animate-in zoom-in duration-300">
            <p class="text-gray-400 mb-6 font-medium">Scan QR untuk upload file</p>
            <div class="h-64 bg-white mb-6" v-html="qrCode"></div>

            <div class="flex items-center space-x-3 bg-gray-100 px-6 py-3 rounded-full">
                <div class="w-3 h-3 bg-green-500 rounded-full animate-ping"></div>
                <span class="text-sm font-bold text-gray-600">Menunggu file...</span>
            </div>
        </div>
    </div>
</template>
