<script setup>
import { Trash2 } from 'lucide-vue-next';

defineProps({
    show: Boolean,
    title: {
        type: String,
        default: 'Hapus File?'
    },
    message: {
        type: String,
        default: 'File ini akan dihapus permanen dari server.'
    },
    confirmText: {
        type: String,
        default: 'Hapus'
    },
    isBulk: Boolean
});

defineEmits(['close', 'confirm']);
</script>

<template>
    <div v-if="show" class="fixed inset-0 z-[60] flex items-center justify-center bg-black/50 backdrop-blur-sm">
        <div class="bg-white rounded-2xl p-8 w-96 text-center shadow-xl">
            <div v-if="isBulk"
                class="w-16 h-16 bg-red-50 text-red-600 rounded-full flex items-center justify-center mx-auto mb-4">
                <Trash2 class="w-8 h-8" />
            </div>
            <h3 class="text-xl font-bold text-gray-900 mb-2">{{ title }}</h3>
            <p class="text-gray-500 mb-6">{{ message }}</p>
            <div class="flex gap-3">
                <button @click="$emit('close')"
                    class="flex-1 py-3 bg-gray-100 hover:bg-gray-200 rounded-xl font-bold text-gray-700">
                    Batal
                </button>
                <button @click="$emit('confirm')"
                    class="flex-1 py-3 bg-red-600 hover:bg-red-700 rounded-xl font-bold text-white shadow-lg shadow-red-200">
                    {{ confirmText }}
                </button>
            </div>
        </div>
    </div>
</template>
