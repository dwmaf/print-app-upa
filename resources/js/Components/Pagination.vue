<template>
    <div v-if="links.length > 3"
        class="inline-flex items-stretch border border-gray-300 dark:border-gray-600 divide-x-2 divide-gray-300 dark:divide-gray-600 rounded-lg overflow-hidden">
        <template v-for="(link, key) in links" :key="key">
            <template v-if="key === 0 && link.url">
                <Link :href="link.url ?? '#'" :disabled="!link.url"
                    class="px-2 py-2 text-sm font-bold flex items-center dark:text-gray-100 text-gray-700 justify-center"
                    :class="{
                        'cursor-not-allowed': !link.url,
                        'hover:bg-gray-100 dark:hover:bg-gray-700': link.url
                    }">
                <ChevronLeft class="w-4 h-4 " />

                </Link>
            </template>
            <template v-else-if="key === links.length - 1 && link.url">
                <Link :href="link.url ?? '#'" :disabled="!link.url"
                    class="px-2 py-2 text-sm font-bold flex items-center dark:text-gray-100 text-gray-700 justify-center"
                    :class="{
                        'cursor-not-allowed': !link.url,
                        'hover:bg-gray-100 dark:hover:bg-gray-700': link.url
                    }">
                <ChevronRight class="w-4 h-4 " />
                </Link>
            </template>

            <template v-else-if="key !== 0 && key !== links.length - 1">
                <div v-if="link.url === null" class="px-3 py-2 text-sm text-gray-500 " v-html="link.label" />
                <Link v-else class="px-3 py-2 text-sm font-bold hover:bg-gray-100 dark:hover:bg-gray-700"
                    :class="[link.active ? 'text-indigo-700 dark:text-indigo-400' : 'dark:text-white text-gray-700']"
                    :href="link.url" v-html="link.label" />
            </template>
        </template>
    </div>
    <div v-if="links.length < 3" class="flex justify-between w-full">
        <Link v-if="links[0].url" :href="links[0].url"
            class="px-4 py-2 text-sm font-bold flex items-center dark:text-gray-100 text-gray-700 justify-center border border-gray-300 dark:border-gray-600 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700">
            <span>Previous</span>
        </Link>
        <div v-else></div>
        <Link v-if="links[links.length - 1].url" :href="links[links.length - 1].url"
            class="px-4 py-2 text-sm font-bold flex items-center dark:text-gray-100 text-gray-700 justify-center border border-gray-300 dark:border-gray-600 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700">
            <span>Next</span>
        </Link>
    </div>
</template>

<script setup>
import { Link } from '@inertiajs/vue3';
import { ChevronLeft, ChevronRight } from 'lucide-vue-next';

defineProps({
    links: Array,
});
</script>