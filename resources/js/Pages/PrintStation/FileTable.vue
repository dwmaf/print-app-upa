<script setup>
import { ref } from 'vue';
import { Trash2, Printer, QrCode as QrIcon, Eye, EyeOff } from 'lucide-vue-next';

const props = defineProps({
    filetoprints: Array,
    selectedIds: Array,
    stationName: String,
    qrCode: String,
});

const emit = defineEmits(['openPrintModal', 'openDeleteModal', 'deleteMultiple', 'updateSelectedIds']);

const showLocalQr = ref(false);

const toggleSelectAll = (checked) => {
    const ids = checked ? props.filetoprints.map(f => f.id) : [];
    emit('updateSelectedIds', ids);
};

const toggleSelect = (id, checked) => {
    let newIds = [...props.selectedIds];
    if (checked) {
        newIds.push(id);
    } else {
        newIds = newIds.filter(i => i !== id);
    }
    emit('updateSelectedIds', newIds);
};

const formatTime = (dateStr) => {
    const date = new Date(dateStr);
    const now = new Date();
    const diffInSeconds = Math.floor((now - date) / 1000);

    const rtf = new Intl.RelativeTimeFormat('en', { numeric: 'always' });

    if (diffInSeconds < 60) {
        return rtf.format(-diffInSeconds, 'second');
    }

    const diffInMinutes = Math.floor(diffInSeconds / 60);
    if (diffInMinutes < 60) {
        return rtf.format(-diffInMinutes, 'minute');
    }

    const diffInHours = Math.floor(diffInMinutes / 60);
    if (diffInHours < 24) {
        return rtf.format(-diffInHours, 'hour');
    }

    const diffInDays = Math.floor(diffInHours / 24);
    if (diffInDays < 30) {
        return rtf.format(-diffInDays, 'day');
    }

    return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
};
</script>

<template>
    <div class="bg-white w-full h-full rounded-xl shadow-lg px-8">
        <div v-if="showLocalQr" class="flex justify-center animate-in zoom-in duration-300">
            <div class="bg-white p-6 rounded-2xl shadow-xl flex flex-col items-center border border-indigo-50">
                <div class="w-44 h-44" v-html="qrCode"></div>
            </div>
        </div>

        <div class="flex items-center justify-between mb-6">
            <div class="flex items-center gap-4">
                <img src="/images/logo.png" class="w-18" alt="Logo">
                <div>
                    <h1 class="text-5xl font-koulen">Printation</h1>
                    <p class="uppercase font-medium text-gray-400 font-roboto">{{ stationName }}</p>
                </div>
                <!-- Toggle Lokal: Tidak perlu emit -->
                <button @click="showLocalQr = !showLocalQr"
                    class="flex items-center gap-2 px-4 py-2 text-xs font-bold rounded-full transition-all border shadow-sm ml-2"
                    :class="showLocalQr ? 'bg-amber-500 text-white border-amber-600' : 'bg-white text-indigo-600 border-indigo-100 hover:bg-indigo-50'">
                    <component :is="showLocalQr ? EyeOff : QrIcon" class="w-4 h-4" />
                    {{ showLocalQr ? 'Tutup QR' : 'Tampilkan QR' }}
                </button>
                <button v-if="selectedIds.length > 0" @click="$emit('deleteMultiple')"
                    class="flex items-center gap-2 px-4 py-2 bg-red-600 hover:bg-red-700 text-white text-xs font-bold rounded-full transition-all shadow-lg shadow-red-100 animate-in fade-in slide-in-from-right-4 duration-200">
                    <Trash2 class="w-4 h-4" />
                    Hapus {{ selectedIds.length }} File
                </button>
            </div>
            <div class="flex items-center gap-4">
                <div class="text-gray-500 font-bold">{{ filetoprints.length }} file terupload</div>
            </div>
        </div>

        <div class="w-full max-h-[65vh] overflow-y-auto">
            <table class="w-full border-collapse">
                <thead class="bg-gray-100 sticky top-0 z-10">
                    <tr class="text-left text-sm font-semibold text-gray-700">
                        <th class="p-3 text-center">
                            <input type="checkbox"
                                :checked="selectedIds.length === filetoprints.length && filetoprints.length > 0"
                                @change="(e) => toggleSelectAll(e.target.checked)"
                                class="w-4 h-4 accent-blue-600 rounded cursor-pointer">
                        </th>
                        <th class="p-3 text-lg text-center">Tipe</th>
                        <th class="p-3 text-lg">Nama File</th>
                        <th class="p-3 text-lg">Diunggah</th>
                        <th class="p-3 text-lg text-center">Status</th>
                        <th class="p-3 text-lg text-center">Aksi</th>
                    </tr>
                </thead>
                <tbody class="divide-y">
                    <tr v-for="file in filetoprints" :key="file.id" class="hover:bg-blue-50/50 transition-colors">
                        <td class="p-4 text-center">
                            <input type="checkbox" :checked="selectedIds.includes(file.id)"
                                @change="(e) => toggleSelect(file.id, e.target.checked)"
                                class="w-4 h-4 accent-blue-600 rounded cursor-pointer">
                        </td>
                        <td class="p-4">
                            <div class="font-black text-xs px-2 py-1 rounded w-fit"
                                :class="file.type === 'PDF' ? 'bg-red-100 text-red-600' : 'bg-blue-100 text-blue-600'">
                                {{ file.type }}
                            </div>
                        </td>
                        <td class="p-4 font-medium text-gray-900 max-w-xs truncate">
                            {{ file.original_name }}
                            <div v-if="file.latest_print_request" class="mt-1">
                                <span class="text-[10px] bg-yellow-100 text-yellow-800 px-1.5 py-0.5 rounded font-bold">
                                    REQ: {{ file.latest_print_request.request_id }}
                                </span>
                            </div>
                        </td>
                        <td class="p-4 text-sm text-gray-500">
                            {{ formatTime(file.created_at) }}
                        </td>
                        <td class="p-4 text-center">
                            <span v-if="!file.latest_print_request"
                                class="px-3 py-1 rounded-full text-xs font-bold bg-gray-100 text-gray-500">
                                BELUM REQ
                            </span>
                            <span v-else-if="file.status === 'pending'"
                                class="px-3 py-1 rounded-full text-xs font-bold bg-yellow-100 text-yellow-700">
                                PENDING
                            </span>
                            <span v-else-if="file.status === 'verified'"
                                class="px-3 py-1 rounded-full text-xs font-bold bg-green-100 text-green-700">
                                VERIFIED
                            </span>
                            <span v-else-if="file.status === 'rejected'"
                                class="px-3 py-1 rounded-full text-xs font-bold bg-red-100 text-red-700">
                                REJECTED
                            </span>
                            <span v-else-if="file.status === 'completed'"
                                class="px-3 py-1 rounded-full text-xs font-bold bg-blue-100 text-blue-700">
                                COMPLETED
                            </span>
                        </td>
                        <td class="p-4 text-center">
                            <div class="flex justify-center gap-2">
                                <button @click="$emit('openPrintModal', file)" class="p-2 rounded-lg transition-colors"
                                    :class="{
                                        'bg-indigo-50 hover:bg-indigo-100 text-indigo-600': !file.status || ['new', 'rejected'].includes(file.status),
                                        'bg-yellow-50 hover:bg-yellow-100 text-yellow-600': file.status === 'pending',
                                        'bg-green-50 hover:bg-green-100 text-green-600': file.status === 'verified',
                                        'bg-blue-50 hover:bg-blue-100 text-blue-600': file.status === 'completed',
                                    }" title="Print Options">
                                    <Printer class="w-5 h-5" />
                                </button>

                                <button @click="$emit('openDeleteModal', file)"
                                    class="p-2 bg-red-50 hover:bg-red-100 text-red-600 rounded-lg transition-colors"
                                    title="Hapus File">
                                    <Trash2 class="w-5 h-5" />
                                </button>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</template>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
    width: 6px;
}

.custom-scrollbar::-webkit-scrollbar-track {
    background: #f1f1f1;
}

.custom-scrollbar::-webkit-scrollbar-thumb {
    background: #cbd5e1;
    border-radius: 10px;
}

.custom-scrollbar::-webkit-scrollbar-thumb:hover {
    background: #94a3b8;
}
</style>
