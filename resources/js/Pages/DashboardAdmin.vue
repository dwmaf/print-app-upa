<script setup>
import { Head } from '@inertiajs/vue3';
import { Printer, TrendingUp, TrendingDown, BarChart3 } from 'lucide-vue-next';
import AdminLayout from '@/Layouts/AdminLayout.vue';
import VueApexCharts from "vue3-apexcharts"; // Install: npm install vue3-apexcharts apexcharts

const props = defineProps({
    stats: Object
});

const chartOptions = {
    chart: { type: 'bar', toolbar: { show: false } },
    plotOptions: { bar: { borderRadius: 4, columnWidth: '50%' } },
    dataLabels: { enabled: false },
    colors: ['#4F46E5'],
    xaxis: { categories: props.stats.chartData.map(d => d.month) }
};

const chartSeries = [{
    name: 'Total Lembar',
    data: props.stats.chartData.map(d => d.total)
}];
</script>

<template>

    <Head title="Admin Dashboard" />

    <AdminLayout>
        <template #header>
            <h1 class="text-3xl text-gray-800 font-koulen uppercase tracking-wide">
                Dashboard
            </h1>
        </template>

        <div class="h-full">
            <div class="grid grid-cols-6 grid-rows-6 gap-4 h-full">

                <!-- KERTAS TERPRINT CARD bulanan-->                
                <div
                    class="col-span-2 row-span-2 shadow-md rounded-xl p-6 flex flex-col justify-between bg-white relative overflow-hidden group hover:shadow-lg transition-all duration-300">
                    <div class="flex justify-between items-start z-10">
                        <div>
                            <p class="font-bold text-lg text-gray-700">Total Lembar Terprint</p>
                            <p class="font-medium text-xs text-gray-400">Bulan Ini</p>
                        </div>
                        <div class="p-2 bg-blue-100/50 rounded-2xl group-hover:scale-110 transition-transform">
                            <Printer class="w-6 h-6 text-blue-600" />
                        </div>
                    </div>

                    <div class="z-10">
                        <p class="text-4xl font-extrabold text-gray-800 mb-2 mt-2">{{ stats.sheetsThisMonth }} Lembar
                        </p>
                        <div class="flex items-center gap-2">
                            <div :class="parseFloat(stats.trendPercentage) >= 0 ? 'bg-green-100' : 'bg-red-100'"
                                class="p-0.5 rounded-full">
                                <TrendingUp v-if="parseFloat(stats.trendPercentage) >= 0"
                                    class="w-3 h-3 text-green-600" />
                                <TrendingDown v-else class="w-3 h-3 text-red-600" />
                            </div>
                            <span :class="parseFloat(stats.trendPercentage) >= 0 ? 'text-green-500' : 'text-red-500'"
                                class="font-bold text-sm">
                                {{ stats.trendPercentage }}
                            </span>
                            <span class="text-xs text-gray-400">dari bulan lalu</span>
                        </div>
                    </div>

                    <!-- Decorative gradient/shape -->
                    <div class="absolute -bottom-4 -right-4 w-24 h-24 bg-blue-50 rounded-full blur-2xl opacity-50">
                    </div>
                </div>

                <!-- TOTAL LEMBAR SEPANJANG MASA CARD -->
                <div
                    class="col-span-2 row-span-2 shadow-md rounded-xl p-6 flex flex-col justify-between bg-white relative overflow-hidden group hover:shadow-lg transition-all duration-300">
                    <div class="flex justify-between items-start z-10">
                        <div>
                            <p class="font-bold text-lg text-gray-700">Total Terprint</p>
                            <p class="font-medium text-xs text-gray-400">Sepanjang Masa</p>
                        </div>
                        <div class="p-2 bg-purple-100/50 rounded-2xl group-hover:scale-110 transition-transform">
                            <Printer class="w-6 h-6 text-purple-600" />
                        </div>
                    </div>

                    <div class="z-10">
                        <p class="text-4xl font-extrabold text-gray-800 mb-2 mt-2">{{ stats.sheetsAllTime }} Lembar</p>
                        <div class="flex items-center gap-2">
                            <span class="text-xs text-gray-400 font-medium italic">Akumulasi seluruh kertas
                                terprint</span>
                        </div>
                    </div>

                    <!-- Decorative shape -->
                    <div class="absolute -bottom-4 -right-4 w-24 h-24 bg-purple-50 rounded-full blur-2xl opacity-50">
                    </div>
                </div>

                <!-- apex charts -->
                <div class="col-span-4 row-span-4 bg-white shadow-md rounded-xl p-6">
                    <div class="flex items-center gap-2 mb-6">
                        <BarChart3 class="w-5 h-5 text-gray-400" />
                        <h3 class="font-bold text-gray-700">Statistik Pencetakan (6 Bulan Terakhir)</h3>
                    </div>
                    <VueApexCharts type="bar" height="300" :options="chartOptions" :series="chartSeries" />
                </div>
            </div>
        </div>
    </AdminLayout>
</template>
