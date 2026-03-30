<script setup>
import { computed, ref, watch, nextTick } from 'vue';
import { Printer, Clock, CheckCircle, X } from 'lucide-vue-next';

const props = defineProps({
    show: Boolean,
    currentFile: Object,
    config: Object,
    loading: Boolean,
});

const emit = defineEmits(['close', 'submit', 'execute']);

const isImage = computed(() => {
    if (!props.currentFile) return false;
    const type = props.currentFile.type.toUpperCase();
    return ['JPG', 'JPEG', 'PNG', 'WEBP'].includes(type);
});

const customPagesInput = ref(null);

watch(() => props.config.pageOption, (newVal) => {
    if (newVal === 'custom') {
        nextTick(() => {
            customPagesInput.value?.focus();
        });
    }
});

// buat ngitung jumlah halaman
const calculatedPages = computed(() => {
    if (props.config.pageOption === 'all') return props.config.pages;

    const rangeStr = props.config.customPages;
    if (!rangeStr || !rangeStr.trim()) return 0;

    const pages = new Set();
    const parts = rangeStr.replace(/\s+/g, '').split(',');

    parts.forEach(part => {
        if (part.includes('-')) {
            const [start, end] = part.split('-').map(Number);
            if (!isNaN(start) && !isNaN(end)) {
                for (let i = Math.max(1, start); i <= Math.min(props.config.pages, end); i++) {
                    pages.add(i);
                }
            }
        } else {
            const num = Number(part);
            if (!isNaN(num) && num >= 1 && num <= props.config.pages) {
                pages.add(num);
            }
        }
    });
    return pages.size;
});

const totalPageCount = computed(() => {
    return calculatedPages.value * props.config.copies;
});

</script>

<template>
    <div v-if="show" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-sm"
        @click.self="$emit('close')">
        <div
            class="bg-white rounded-2xl w-full max-w-6xl h-[85vh] flex shadow-2xl overflow-hidden animate-in fade-in zoom-in duration-200">

            <!-- PREVIEW -->
            <div class="w-2/3 bg-gray-200 relative flex items-center justify-center border-r border-gray-300">
                <iframe :src="currentFile.url + '#toolbar=0&navpanes=0&scrollbar=0&view=FitH'"
                    class="w-full h-full bg-white"></iframe>
            </div>

            <!-- CONFIG PANEL -->
            <div class="w-1/3 bg-gray-50 flex flex-col h-full ">
                <!-- Headernya -->
                <div class="flex justify-between items-start p-6 pb-3 shrink-0 bg-gray-50 z-10">
                    <h2 class="text-3xl font-koulen">Konfigurasi</h2>
                    <button @click="$emit('close')"
                        class="text-gray-400 hover:text-red-500 transition-colors cursor-pointer">
                        <X class="w-8 h-8" />
                    </button>
                </div>

                <div class="flex-1 overflow-y-auto p-6 space-y-6">
                    <!-- File Info -->
                    <div class="bg-white p-4 rounded-xl border border-gray-200 shadow-sm">
                        <div class="text-sm font-bold text-gray-900 whitespace-normal break-all">{{
                            currentFile.original_name }}</div>
                        <div class="text-xs text-gray-400 font-bold mt-1">
                            <span class="uppercase">{{ currentFile.type }}</span> • {{ config.pages }} Halaman
                        </div>
                    </div>

                    <!-- Configs (ONLY SHOW FOR NEW/REJECTED/COMPLETED) -->
                    <div v-if="!currentFile.status || ['new', 'rejected', 'new_upload', 'completed'].includes(currentFile.status)"
                        class="space-y-4">
                        <!-- Paper Size -->
                        <div class="bg-white p-4 rounded-xl border border-gray-200 shadow-sm">
                            <label class="block text-xs font-bold text-gray-500 uppercase mb-2">Ukuran Kertas</label>
                            <select v-model="config.paperSize"
                                class="w-full bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:outline-blue-500 p-2.5 font-bold">
                                <option value="A4">A4</option>
                                <option value="Legal">Legal / F4</option>
                            </select>
                        </div>

                        <!-- Page Range -->
                        <div class="bg-white p-4 rounded-xl border border-gray-200 shadow-sm">
                            <label class="block text-xs font-bold text-gray-500 uppercase mb-2">Rentang Halaman</label>
                            <div class="flex items-center mb-3 space-x-4">
                                <label class="flex items-center cursor-pointer">
                                    <input type="radio" value="all" v-model="config.pageOption"
                                        class="w-4 h-4 accent-indigo-600 cursor-pointer">
                                    <span class="ml-2 text-sm font-medium text-gray-900">Semua</span>
                                </label>
                                <label class="flex items-center cursor-pointer">
                                    <input type="radio" value="custom" v-model="config.pageOption"
                                        class="w-4 h-4 text-indigo-600 focus:outline-indigo-600 accent-indigo-600 cursor-pointer">
                                    <span class="ml-2 text-sm font-medium text-gray-900">Custom</span>
                                </label>
                            </div>
                            <div v-if="config.pageOption === 'custom'">
                                <input type="text" v-model="config.customPages" ref="customPagesInput"
                                    placeholder="Contoh: 1-5, 8, 11-13"
                                    class="w-full text-sm font-bold border-gray-300 rounded-lg focus:outline-indigo-500 p-2.5">
                                <p class="text-[10px] text-gray-400 mt-1 font-semibold">Gunakan tanda hubung ( - ) untuk
                                    rentang dan koma ( , ) untuk halaman acak.</p>
                            </div>
                        </div>

                        <!-- Copies -->
                        <div class="bg-white p-4 rounded-xl border border-gray-200 shadow-sm">
                            <label class="block text-xs font-bold text-gray-500 uppercase mb-2">Jumlah Copy</label>
                            <div class="flex items-center">
                                <button @click="config.copies = Math.max(1, config.copies - 1)"
                                    class="w-10 h-10 bg-gray-100 rounded-l-lg hover:bg-gray-200 font-bold cursor-pointer">-</button>
                                <input type="number" v-model="config.copies"
                                    class="w-full text-center text-xl font-bold text-gray-800 border-y border-x-0 border-gray-200 h-10 focus:ring-0"
                                    readonly>
                                <button @click="config.copies++"
                                    class="w-10 h-10 bg-gray-100 rounded-r-lg hover:bg-gray-200 font-bold cursor-pointer">+</button>
                            </div>
                        </div>

                        <!-- Color Mode -->
                        <div class="bg-white p-4 rounded-xl border border-gray-200 shadow-sm">
                            <label class="block text-xs font-bold text-gray-500 uppercase mb-2">Mode Warna</label>
                            <div class="grid grid-cols-2 gap-2">
                                <label class="cursor-pointer">
                                    <input type="radio" value="color" v-model="config.colorMode" class="peer sr-only">
                                    <div
                                        class="p-2 rounded-lg border-2 border-gray-200 peer-checked:border-blue-600 peer-checked:bg-blue-50 text-center transition-all hover:bg-gray-50">
                                        <span class="font-bold text-sm block text-gray-700">Berwarna</span>
                                    </div>
                                </label>
                                <label class="cursor-pointer group">
                                    <input type="radio" value="bw" v-model="config.colorMode" class="peer sr-only">
                                    <div
                                        class="p-2 rounded-lg border-2 border-gray-200 peer-checked:border-blue-600 peer-checked:bg-blue-50 text-center transition-all hover:bg-gray-50">
                                        <span class="font-bold text-sm text-gray-700">Hitam Putih</span>
                                    </div>
                                </label>
                            </div>
                        </div>

                        <!-- Kalkulasi jumlah halaman -->
                        <div class="bg-blue-50 border border-blue-200 p-4 rounded-xl mt-6">
                            <div class="flex justify-between items-center text-sm text-gray-600 mb-2 font-semibold">
                                <span>Kalkulasi</span>
                                <span class="font-bold">{{ calculatedPages }} Hal x {{ config.copies }} Copy</span>
                            </div>

                            <div class="border-t border-blue-200 pt-3 flex justify-between items-center">
                                <span class="font-extrabold text-blue-900 text-lg">TOTAL</span>
                                <span class="font-black text-2xl text-blue-600">{{ totalPageCount }} Halaman</span>
                            </div>
                        </div>

                    </div>

                    <!-- PENDING / VERIFIED INFO -->
                    <div v-else class="space-y-6">
                        <div class="bg-indigo-50 p-4 rounded-xl border border-indigo-100">
                            <p class="text-[10px] text-indigo-400 font-bold uppercase mb-2">Konfigurasi Terpilih</p>
                            <div class="grid grid-cols-2 gap-y-3 gap-x-2">
                                <div>
                                    <p class="text-[9px] text-gray-400 uppercase font-bold">Kertas</p>
                                    <p class="text-xs font-black text-gray-700">{{ config.paperSize }}</p>
                                </div>
                                <div>
                                    <p class="text-[9px] text-gray-400 uppercase font-bold">Warna</p>
                                    <p class="text-xs font-black text-gray-700 uppercase">{{ config.colorMode ===
                                        'color' ? 'Berwarna' : 'H/P' }}</p>
                                </div>
                                <div>
                                    <p class="text-[9px] text-gray-400 uppercase font-bold">Copy</p>
                                    <p class="text-xs font-black text-gray-700">{{ config.copies }}x</p>
                                </div>
                                <div>
                                    <p class="text-[9px] text-gray-400 uppercase font-bold">Hal</p>
                                    <p class="text-xs font-black text-gray-700">{{ config.pageOption === 'all' ? 'Semua'
                                        : config.customPages }}</p>
                                </div>
                            </div>
                        </div>

                        <!-- Status Displays -->
                        <div v-if="currentFile.status === 'pending'" class="text-center py-4">
                            <div
                                class="w-20 h-20 bg-yellow-100 text-yellow-600 rounded-full flex items-center justify-center mx-auto mb-4 animate-pulse">
                                <Clock class="w-10 h-10" />
                            </div>
                            <h3 class="text-xl font-black text-yellow-700 uppercase">MENUNGGU KONFIRMASI</h3>
                            <p class="text-sm text-yellow-500 font-bold mt-2">Daftar verifikasi Anda sedang diproses
                                oleh admin.</p>
                            <div
                                class="mt-10 bg-white p-4 rounded-xl border-2 border-yellow-200 border-dashed text-center">
                                <p class="text-[10px] text-gray-400 font-bold uppercase mb-1">Kode Request</p>
                                <p class="text-2xl font-black text-yellow-700 font-mono tracking-widest">{{
                                    currentFile.latest_print_request.request_id }}</p>
                            </div>
                        </div>

                        <div v-if="currentFile.status === 'verified'" class="text-center py-4">
                            <div
                                class="w-20 h-20 bg-green-100 text-green-600 rounded-full flex items-center justify-center mx-auto mb-4">
                                <CheckCircle class="w-10 h-10" />
                            </div>
                            <h3 class="text-xl font-black text-green-700 uppercase">SIAP DICETAK</h3>
                            <p class="text-sm text-green-500 font-bold mt-2">Permintaan telah disetujui. Silakan tekan
                                tombol cetak.</p>
                        </div>
                    </div>

                    <!-- Footer Buttons -->
                    <div class="pt-2 space-y-3">
                        <div
                            v-if="!currentFile.status || ['new', 'rejected', 'new_upload', 'completed'].includes(currentFile.status)">
                            <button @click="$emit('submit')"
                                class="w-full items-center py-4 bg-indigo-600 hover:bg-indigo-500 text-white rounded-xl font-black text-lg shadow-lg transition-all cursor-pointer flex justify-center gap-4">
                                <span>SUBMIT REQUEST</span>
                                <CheckCircle class="w-5 h-5" />
                            </button>
                        </div>

                        <div v-else-if="currentFile.status === 'verified'" class="space-y-4">
                            <div class="bg-white p-4 rounded-xl border-2 border-green-200 border-dashed text-center">
                                <p class="text-[10px] text-gray-400 font-bold uppercase mb-1">Kode Request</p>
                                <p class="text-2xl font-black text-green-700 font-mono tracking-widest">{{
                                    currentFile.latest_print_request.request_id }}</p>
                            </div>

                            <button @click="$emit('execute')" :disabled="loading"
                                class="w-full py-4 bg-green-600 hover:bg-green-700 text-white rounded-xl font-black text-lg shadow-lg shadow-green-200 transition-all flex items-center justify-center gap-2 disabled:opacity-50 disabled:cursor-not-allowed">
                                <span v-if="loading">MENCETAK...</span>
                                <span v-else>CETAK SEKARANG</span>
                                <Printer v-if="!loading" class="w-5 h-5" />
                            </button>
                        </div>



                        <button @click="$emit('close')"
                            class="w-full py-3 text-gray-500 hover:text-gray-800 font-bold transition-colors cursor-pointer">Tutup</button>
                    </div>
                </div>


            </div>
        </div>
    </div>
</template>
