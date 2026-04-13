<script setup>
import { ref } from 'vue';
import { Head, useForm } from '@inertiajs/vue3';
import { UploadCloud, CheckCircle, XCircle, FileText, Image as ImageIcon } from 'lucide-vue-next';
const props = defineProps({
});
// FORM
const form = useForm({
    files: [],
    _method: 'POST',
});

const fileInput = ref(null);
const dragging = ref(false);

// METHODS
const handleFiles = (e) => {
    const files = Array.from(e.target.files || e.dataTransfer.files);
    if (files.length > 0) {
        form.files = files;
        submit();
    }
};

const submit = () => {
    form.post(route('upa.upload.store'), {
        preserveScroll: true,
        onSuccess: () => {
            form.reset('files');
            if (fileInput.value) fileInput.value.value = '';
        },
    });
};

const triggerInput = () => {
    if (fileInput.value) fileInput.value.click();
};

const onDragOver = () => dragging.value = true;
const onDragLeave = () => dragging.value = false;
const onDrop = (e) => {
    dragging.value = false;
    handleFiles(e);
};
</script>

<template>
    <Head title="Upload File"></Head>
    <div class="h-screen flex flex-col items-center justify-center p-6 bg-[#FAFAFA] font-roboto">

        <!-- HEADER -->
        <div class="flex flex-col items-center mb-8">
            <div class="flex items-center gap-2 mb-2">
                <img src="/images/logo.png" class="w-12 h-12" alt="Logo">
                <h1 class="text-4xl font-koulen text-gray-900 leading-none">PRINTATION</h1>
            </div>
            <h2 class="uppercase font-bold text-gray-400 font-roboto tracking-wider text-sm">
                UPA PK2 UNTAN
            </h2>
        </div>

        <!-- UPLOAD AREA -->
        <div @click="triggerInput" @dragover.prevent="onDragOver" @dragleave.prevent="onDragLeave"
            @drop.prevent="onDrop"
            class="w-full max-w-sm aspect-square bg-[#F7F8FF] border-2 border-dashed rounded-[30px] flex flex-col items-center justify-center p-8 transition-all cursor-pointer relative overflow-hidden group"
            :class="dragging ? 'border-brand-600 bg-blue-50' : 'border-[#6155F5] hover:bg-blue-50'">
            <input type="file" ref="fileInput" class="hidden" multiple @change="handleFiles"
                accept=".pdf,.jpg,.jpeg,.png,.docx">

            <!-- Loading State -->
            <div v-if="form.processing"
                class="absolute inset-0 bg-white/80 backdrop-blur-sm z-10 flex flex-col items-center justify-center">
                <div class="w-16 h-16 border-4 border-indigo-200 border-t-indigo-600 rounded-full animate-spin mb-4">
                </div>
                <p class="font-bold text-indigo-600 animate-pulse">Mengunggah...</p>
            </div>

            <!-- Content -->
            <img src="/images/upload.png"
                class="w-24 mb-6 opacity-80 group-hover:scale-110 transition-transform duration-300" alt="Upload">

            <p class="text-xl font-bold text-gray-800 text-center mb-1">
                Klik disini untuk <br> mengunggah file
            </p>

            <span class="text-xs text-gray-400 text-center mt-2 leading-relaxed font-medium">
                Format PDF, PNG, JPG, JPEG <br>
                Maks. 10MB
            </span>
        </div>

        <!-- SUCCESS MESSAGE -->
        <div v-if="$page.props.flash.success"
            class="mt-6 flex flex-col items-center animate-in fade-in slide-in-from-bottom-4">
            <div class="flex items-center gap-2 text-green-600 font-bold text-lg">
                <CheckCircle class="w-6 h-6" />
                <span>{{ $page.props.flash.success }}</span>
            </div>
            <p class="text-gray-500 text-sm mt-1 font-medium">Silakan cek di layar monitor station</p>
        </div>

        <!-- ERROR MESSAGE -->
        <div v-if="$page.props.errors.files"
            class="mt-6 flex flex-col items-center animate-in fade-in slide-in-from-bottom-4">
            <div class="flex items-center gap-2 text-red-600 font-bold text-lg text-center">
                <XCircle class="w-6 h-6" />
                <span>{{ $page.props.errors.files }}</span>
            </div>
            <p class="text-gray-500 text-sm mt-1 font-medium">Coba file lain</p>
        </div>
        <!-- GENERIC ERROR -->
        <div v-if="Object.keys($page.props.errors).length > 0 && !$page.props.errors.files"
            class="mt-6 flex flex-col items-center animate-in fade-in slide-in-from-bottom-4">
            <div class="flex items-center gap-2 text-red-600 font-bold text-lg text-center">
                <XCircle class="w-6 h-6" />
                <span>Terjadi Kesalahan</span>
            </div>
            <ul class="text-gray-500 text-sm mt-1 font-medium list-disc">
                <li v-for="(error, key) in $page.props.errors" :key="key">{{ error }}</li>
            </ul>
        </div>

    </div>
</template>
