<script setup>
import { Head, useForm, router} from '@inertiajs/vue3';
import { ref, watch, onMounted } from 'vue';
import { Search, Check, X } from 'lucide-vue-next';
import AdminLayout from '@/Layouts/AdminLayout.vue';
import Pagination from '@/Components/Pagination.vue';

const props = defineProps({
    printrequests: Object,
    filters: Object,
});

const search = ref(props.filters.search);

watch(search, (value) => {
    router.get(route('admin.upa.verify-print.index'), { search: value }, {
        preserveState: true,
        replace: true
    });
});

onMounted(() => {
    if (window.Echo) {
        // Listen ke channel ketika permintaan cetak dikirim/diperbarui statusnya
        window.Echo.channel('admin-upa-channel')
            .listen('.request.created', (e) => {
                console.log('New request created, refreshing...');
                router.reload({ preserveScroll: true });
            })
            .listen('.request.updated', (e) => {
                console.log('Request updated, refreshing...');
                router.reload({ preserveScroll: true });
            });
    }
});

const getStatusStyle = (status) => {
    switch (status) {
        case 'pending': return 'bg-yellow-50 text-yellow-600';
        case 'completed': return 'bg-green-50 text-green-600';
        case 'rejected': return 'bg-red-50 text-red-600';
        case 'completed': return 'bg-blue-50 text-blue-600';
        default: return 'bg-gray-100 text-gray-600';
    }
};

const getStatusLabel = (status) => {
    switch (status) {
        case 'pending': return 'PENDING';
        case 'rejected': return 'DITOLAK';
        default: return status.toUpperCase();
    }
};

const verify = (id) => {
    if (confirm('Verifikasi order ini?')) {
        useForm({ action: 'verify' }).post(route('admin.upa.verify-print.action', { id }));
    }
};

const reject = (id) => {
    if (confirm('Tolak order ini?')) {
        useForm({ action: 'reject' }).post(route('admin.upa.verify-print.action', { id }));
    }
};

</script>

<template>
    <Head title="Admin | Verify Print"></Head>
    <AdminLayout>
        <template #header>
            <h1 class="text-xl sm:text-2xl md:text-3xl text-gray-800 font-koulen uppercase tracking-wide">
                Verifikasi Print
            </h1>
        </template>

        <div
            class="bg-white rounded-xl sm:rounded-[20px] shadow-sm border border-gray-100 flex-1 flex flex-col p-3 sm:p-6 md:p-8 h-full">

            <!-- Judul & Search -->
            <div
                class="flex flex-col md:flex-row justify-between items-start md:items-center mb-4 md:mb-8 gap-3 md:gap-4">
                <h2 class="text-2xl sm:text-2xl font-bold text-black">Daftar Permintaan Cetak</h2>

                <!-- Search Input -->
                <div class="relative w-full md:w-64">
                    <span class="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-400">
                        <Search class="w-5 h-5" />
                    </span>

                    <input v-model="search" type="text" placeholder="Cari ID File..."
                        class="w-full bg-[#FAFAFA] text-gray-700 text-sm rounded-lg border-none focus:ring-2 focus:ring-indigo-200 focus:bg-white py-2.5 pl-10 pr-4 transition-all">
                </div>
            </div>

            <!-- TABLE - Desktop View (hidden on mobile) -->
            <div class="hidden lg:block overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="text-[#8E8D8D] text-xs font-bold uppercase tracking-wider border-b border-gray-100">
                            <th class="py-4 pr-4">ID</th>
                            <th class="py-4 px-4">STATUS</th>
                            <th class="py-4 px-4">HALAMAN</th>
                            <th class="py-4 px-4">Copy</th>
                            <th class="py-4 px-4 text-center">WARNA</th>
                            <th class="py-4 px-4 text-center">UKURAN</th>
                            <th class="py-4 px-4 text-right">AKSI</th>
                        </tr>
                    </thead>
                    <tbody class="text-sm text-gray-600 divide-y divide-gray-50">
                        <tr v-for="printrequest in printrequests.data" :key="printrequest.id"
                            class="group hover:bg-gray-50 transition-colors">
                            <!-- ID -->
                            <td class="py-5 pr-4 font-semibold text-gray-900">
                                {{ printrequest.request_id }}
                            </td>

                            <!-- STATUS -->
                            <td class="py-5 px-4">
                                <span class="px-3 py-1 rounded-md text-[10px] font-bold"
                                    :class="getStatusStyle(printrequest.status)">
                                    {{ getStatusLabel(printrequest.status) }}
                                </span>
                            </td>

                            <!-- HALAMAN -->
                            <td class="py-5 px-4">
                                {{ printrequest.calculated_pages }} Hal
                            </td>

                            <!-- Copies -->
                            <td class="py-5 px-4">
                                {{ printrequest.copies }} Copy
                            </td>

                            <!-- WARNA -->
                            <td class="py-5 px-4 text-center">
                                <Check v-if="printrequest.color_mode === 'color'" class="w-5 h-5 text-gray-500 mx-auto"
                                    stroke-width="2" />
                                <X v-else class="w-5 h-5 text-gray-300 mx-auto" stroke-width="2" />
                            </td>

                            <!-- UKURAN -->
                            <td class="py-5 px-4 text-center font-medium">
                                {{ printrequest.paper_size?.toUpperCase() }}
                            </td>

                            <!-- AKSI -->
                            <td class="py-5 px-4 text-right">
                                <div v-if="printrequest.status === 'pending'" class="flex justify-end gap-2">
                                    <button @click="verify(printrequest.id)"
                                        class="w-8 h-8 rounded bg-[#4ADE80] text-white flex items-center justify-center hover:bg-green-500 transition shadow-sm cursor-pointer">
                                        <Check class="w-4 h-4" stroke-width="3" />
                                    </button>
                                    <button @click="reject(printrequest.id)"
                                        class="w-8 h-8 rounded bg-[#FB7185] text-white flex items-center justify-center hover:bg-red-500 transition shadow-sm cursor-pointer">
                                        <X class="w-4 h-4" stroke-width="3" />
                                    </button>
                                </div>
                                <div v-else-if="printrequest.status === 'completed'" class="flex justify-end">
                                    <span class="flex items-center gap-1 text-indigo-500 font-bold text-xs bg-indigo-50 px-2 py-1 rounded">
                                        <Check class="w-3 h-3" stroke-width="4" /> TERPRINT
                                    </span>
                                </div>
                                <span v-else class="text-gray-300 text-sm italic block w-fit ml-auto">No Action</span>
                            </td>
                        </tr>

                        <!-- Empty State Example (Hidden if data exists) -->
                        <tr v-if="printrequests.length === 0">
                            <td colspan="8" class="text-center py-10 text-gray-400">
                                Tidak ada data.
                            </td>
                        </tr>

                    </tbody>
                </table>
            </div>

            <!-- MOBILE CARD VIEW (visible on mobile and tablet) -->
            <div class="lg:hidden space-y-3">
                <!-- Empty State -->
                <div v-if="printrequests.data.length === 0" class="text-center py-10 text-gray-400">
                    Tidak ada data.
                </div>

                <!-- Card for each print request -->
                <div v-for="printrequest in printrequests.data" :key="printrequest.id"
                    class="bg-white border-2 border-gray-200 rounded-xl p-4 shadow-sm hover:shadow-md transition-shadow">

                    <!-- Header: ID & Status -->
                    <div class="flex justify-between items-center mb-3">
                        <div class="font-bold text-gray-900 text-lg">{{ printrequest.request_id }}</div>
                        <span class="px-3 py-1.5 rounded-lg text-xs font-bold"
                            :class="getStatusStyle(printrequest.status)">
                            {{ getStatusLabel(printrequest.status) }}
                        </span>
                    </div>

                    <!-- Compact Info Row -->
                    <div
                        class="flex items-center justify-between text-sm text-gray-600 mb-3 pb-3 border-b border-gray-100">
                        <div class="flex items-center gap-4">
                            <span class="font-semibold text-gray-900">
                                {{ printrequest.calculated_pages }} hal
                            </span>
                            <span class="text-gray-400">•</span>
                            <span class="font-semibold text-gray-900">
                                {{ printrequest.copies }} Copy
                            </span>
                        </div>
                    </div>

                    <!-- Second Row: Color & Size -->
                    <div class="flex items-center justify-between mb-3.5">
                        <div class="flex items-center gap-2">
                            <Check v-if="printrequest.color_mode === 'color'" class="w-5 h-5 text-green-600"
                                stroke-width="2.5" />
                            <X v-else class="w-5 h-5 text-gray-400" stroke-width="2.5" />
                            <span class="text-sm font-semibold text-gray-900">
                                {{ printrequest.color_mode === 'color' ? 'Berwarna' : 'Hitam Putih' }}
                            </span>
                        </div>
                        <div class="bg-gray-100 px-3 py-1.5 rounded-md">
                            <span class="font-bold text-gray-900 text-sm">
                                {{ printrequest.paper_size?.toUpperCase() }}
                            </span>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div v-if="printrequest.status === 'pending'" class="flex gap-2.5">
                        <button @click="verify(printrequest.id)"
                            class="flex-1 bg-[#4ADE80] text-white py-3.5 px-4 rounded-lg font-bold text-base hover:bg-green-500 transition shadow-sm flex items-center justify-center gap-2 active:scale-95">
                            <Check class="w-5 h-5" stroke-width="3" />
                            Verifikasi
                        </button>
                        <button @click="reject(printrequest.id)"
                            class="flex-1 bg-[#FB7185] text-white py-3.5 px-4 rounded-lg font-bold text-base hover:bg-red-500 transition shadow-sm flex items-center justify-center gap-2 active:scale-95">
                            <X class="w-5 h-5" stroke-width="3" />
                            Tolak
                        </button>
                    </div>
                    <div v-else class="text-center text-gray-400 py-2 text-sm font-medium">
                        Tidak ada aksi
                    </div>
                </div>
            </div>

            <!-- Pagination -->
            <div
                class="mt-auto pt-6 flex flex-col sm:flex-row justify-between items-center text-xs text-gray-400 gap-3">
                <div class="text-center sm:text-left">
                    Showing {{ printrequests.from }} to {{ printrequests.to }} of {{ printrequests.total }} entries
                </div>
                <Pagination :links="printrequests.links" />
            </div>

        </div>
    </AdminLayout>
</template>