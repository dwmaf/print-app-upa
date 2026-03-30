<script setup>
import { ref, onMounted, watch } from 'vue';
import { Head, useForm, router } from '@inertiajs/vue3';
import axios from 'axios';
import { PDFDocument } from 'pdf-lib';

// COMPONENTS
import EmptyQR from './EmptyQR.vue';
import FileTable from './FileTable.vue';
import PrintConfig from './PrintConfig.vue';
import DeleteModal from './Modals/DeleteModal.vue';

// PROPS
const props = defineProps({
    filetoprints: Array,
    qrCode: String,
    stationId: Number,
});

// STATE
const modalOpen = ref(false);
const deleteModalOpen = ref(false);
const bulkDeleteModalOpen = ref(false);
const loading = ref(false);

const currentFile = ref(null);
const fileToDelete = ref(null);
const selectedIds = ref([]);
const showQr = ref(props.filetoprints.length === 0);

const config = ref({
    copies: 1,
    colorMode: 'color',
    paperSize: 'A4',
    pageOption: 'all',
    customPages: '',
    pages: 1,
});

// WATCHERS
watch(() => props.filetoprints.length, (newLength) => {
    if (newLength === 0) showQr.value = true;
    else showQr.value = false;
});

// METHODS
const openPrintModal = async (file) => {
    currentFile.value = file;
    if (file.latest_print_request) {
        const v = file.latest_print_request;
        config.value = {
            copies: v.copies || 1,
            colorMode: v.color_mode || 'color',
            paperSize: v.paper_size || 'A4',
            pageOption: v.page_range === 'all' ? 'all' : 'custom',
            customPages: v.page_range === 'all' ? '' : v.page_range,
            pages: v.detected_pages || 1,
        };
    } else {
        config.value = { copies: 1, colorMode: 'color', paperSize: 'A4', pageOption: 'all', customPages: '', pages: 1 };
    }

    modalOpen.value = true;

    if (file.type === 'PDF' && !file.latest_print_request) {
        try {

            const proxyUrl = route('upa.station.proxy-pdf', file.id);
            const response = await fetch(proxyUrl);

            if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);

            const arrayBuffer = await response.arrayBuffer();
            // Verifikasi jika arrayBuffer kosong
            if (arrayBuffer.byteLength === 0) throw new Error("File PDF kosong atau corrupt.");

            const pdfDoc = await PDFDocument.load(arrayBuffer, {
                ignoreEncryption: true // Tambahkan ini untuk PDF yang terproteksi ringan
            });

            config.value.pages = pdfDoc.getPageCount();
            console.log("Success detect pages:", config.value.pages);
        } catch (e) {
            console.error("Gagal menghitung halaman:", e);
            config.value.pages = 1; // Fallback jika gagal
        }
    } else if (file.type !== 'PDF' && !file.latest_print_request) {
        config.value.pages = 1;
    }
};

const closePrintModal = () => {
    modalOpen.value = false;
    currentFile.value = null;
};

const submitRequest = () => {
    const form = useForm({
        file_id: currentFile.value.id,
        station_id: props.stationId,
        print_config: {
            copies: config.value.copies,
            color: config.value.colorMode,
            paper: config.value.paperSize,
            pages: config.value.pageOption === 'custom' ? config.value.customPages : 'all',
            detected_pages: config.value.pages
        }
    });

    form.post(route('upa.station.request-print'), {
        onSuccess: () => { modalOpen.value = false; },
        onFinish: () => router.reload(),
    });
};

const executePrint = async () => {
    if (!currentFile.value || !currentFile.value.latest_print_request) return;
    loading.value = true;

    try {
        const response = await axios.post(route('upa.station.print'), {
            request_id: currentFile.value.latest_print_request.id,
        });

        if (response.data.status === 'success') {
            alert(response.data.message);
            closePrintModal();
            router.reload();
        } else {
            alert(response.data.message);
        }
    } catch (error) {
        alert(error.response?.data?.message || 'Gagal mengirim perintah cetak.');
    } finally {
        loading.value = false;
    }
};



const openDeleteModal = (file) => {
    fileToDelete.value = file;
    deleteModalOpen.value = true;
};

const confirmDelete = () => {
    if (fileToDelete.value) {
        router.delete(route('upa.station.destroy', fileToDelete.value.id), {
            onSuccess: () => {
                deleteModalOpen.value = false;
                fileToDelete.value = null;
            }
        });
    }
};

const confirmBulkDelete = () => {
    router.delete(route('upa.station.destroy-multiple'), {
        data: { file_ids: selectedIds.value },
        onSuccess: () => {
            selectedIds.value = [];
            bulkDeleteModalOpen.value = false;
        },
        onError: () => { bulkDeleteModalOpen.value = false; }
    });
};

onMounted(() => {
    if (window.Echo) {
        window.Echo.channel(`printing-channel.${props.stationId}`)
            .listen('.file.uploaded', () => router.reload({ preserveScroll: true }))
            .listen('.transaction.updated', () => router.reload({ preserveScroll: true }));
    }
});
</script>

<template>
    <div class="min-h-screen flex flex-col bg-[#FAFAFA] font-roboto text-gray-800 p-4 md:p-8">

        <!-- EMPTY / QR STATE -->
        <EmptyQR v-if="filetoprints.length === 0 || showQr" :qr-code="qrCode" :show-qr="showQr"
            :station-name="$page.props.auth.user.name" @toggle-qr="showQr = !showQr" />

        <!-- FILE TABLE STATE -->
        <FileTable v-if="filetoprints.length > 0" :filetoprints="filetoprints" :qr-code="qrCode"
             :selected-ids="selectedIds" :station-name="$page.props.auth.user.name"
            @update-selected-ids="(ids) => selectedIds = ids" @open-print-modal="openPrintModal"
            @open-delete-modal="openDeleteModal" @delete-multiple="bulkDeleteModalOpen = true" />

        <!-- MODALS -->
        <PrintConfig :show="modalOpen" :current-file="currentFile" :config="config" :loading="loading"
            @close="closePrintModal" @submit="submitRequest" @execute="executePrint" />

        <DeleteModal :show="deleteModalOpen" @close="deleteModalOpen = false" @confirm="confirmDelete" />

        <DeleteModal :show="bulkDeleteModalOpen" :is-bulk="true" :title="`Hapus ${selectedIds.length} File?`"
            message="Semua file yang dipilih akan dihapus permanen dari server." confirm-text="Hapus Semua"
            @close="bulkDeleteModalOpen = false" @confirm="confirmBulkDelete" />
    </div>
</template>
