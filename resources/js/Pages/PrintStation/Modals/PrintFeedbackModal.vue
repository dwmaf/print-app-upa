<script setup>
import { CheckCircle2, AlertTriangle } from 'lucide-vue-next';

defineProps({
    show: Boolean,
    type: {
        type: String,
        default: 'success'
    },
    title: {
        type: String,
        default: 'Informasi'
    },
    message: {
        type: String,
        default: ''
    }
});

defineEmits(['close']);
</script>

<template>
    <div v-if="show" class="fixed inset-0 z-[70] flex items-center justify-center bg-black/50 backdrop-blur-sm px-4">
        <div class="bg-white rounded-2xl p-8 w-full max-w-md text-center shadow-xl">
            <div v-if="type === 'success'"
                class="w-16 h-16 bg-green-50 text-green-600 rounded-full flex items-center justify-center mx-auto mb-4">
                <CheckCircle2 class="w-8 h-8" />
            </div>
            <div v-else
                class="w-16 h-16 bg-red-50 text-red-600 rounded-full flex items-center justify-center mx-auto mb-4">
                <AlertTriangle class="w-8 h-8" />
            </div>

            <h3 class="text-xl font-bold text-gray-900 mb-2">{{ title }}</h3>
            <p class="text-gray-500 mb-6">{{ message }}</p>

            <button @click="$emit('close')"
                class="w-full py-3 rounded-xl font-bold text-white transition"
                :class="type === 'success' ? 'bg-green-600 hover:bg-green-700' : 'bg-red-600 hover:bg-red-700'">
                OK
            </button>
        </div>
    </div>
</template>
