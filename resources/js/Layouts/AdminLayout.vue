<script setup>
import { Link, usePage, router } from '@inertiajs/vue3';
import { LayoutDashboard, BadgeCheck, LogOut, FileCheck, Menu, X } from 'lucide-vue-next';
import { ref, computed, onMounted, watch, onBeforeUnmount } from 'vue';

const page = usePage();
const mobileMenuOpen = ref(false);
const pendingCount = computed(() => page.props.pendingCount);

const closeMobileMenu = () => {
    mobileMenuOpen.value = false;
};

watch(() => page.url, () => {
    mobileMenuOpen.value = false;
});

watch(mobileMenuOpen, (isOpen) => {
    document.body.style.overflow = isOpen ? 'hidden' : '';
});

onBeforeUnmount(() => {
    document.body.style.overflow = '';
});

onMounted(() => {
    if (window.Echo) {
        window.Echo.channel('admin-upa-channel')
            .listen('.transaction.created', (e) => {
                router.reload({ 
                    only: ['pendingCount'], 
                    preserveScroll: true 
                });
            })
            .listen('.transaction.updated', (e) => {
                router.reload({ 
                    only: ['pendingCount'], 
                    preserveScroll: true 
                });
            });
    }
});
</script>

<template>
    <div class="flex flex-col lg:flex-row p-3 sm:p-6 gap-3 sm:gap-4 min-h-screen bg-gray-100 font-roboto">
        <!-- MOBILE HEADER with hamburger -->
        <div class="lg:hidden bg-white rounded-xl p-4 flex justify-between items-center shadow-sm sticky top-0 z-50">
            <div class="flex items-center gap-2">
                <img src="/images/logo.png" alt="Logo" class="w-8 h-8 object-contain">
                <h1 class="font-koulen text-xl text-gray-800 tracking-wide">Printation</h1>
            </div>
            <button @click="mobileMenuOpen = !mobileMenuOpen" class="p-2 hover:bg-gray-100 rounded-lg transition-colors"
                :aria-expanded="mobileMenuOpen" aria-controls="mobile-sidebar-menu" aria-label="Toggle mobile menu">
                <Menu v-if="!mobileMenuOpen" class="w-6 h-6 text-gray-600" />
                <X v-else class="w-6 h-6 text-gray-600" />
            </button>
        </div>

        <!-- MOBILE MENU OVERLAY -->
        <div v-if="mobileMenuOpen" 
            class="lg:hidden fixed inset-0 bg-black/50 z-40"
            @click="closeMobileMenu">
        </div>

        <!-- SIDEBAR -->
        <div id="mobile-sidebar-menu" class="bg-white rounded-xl flex flex-col shadow-sm shrink-0 transition-all duration-300"
            :class="[
                mobileMenuOpen ? 'fixed top-[5.5rem] left-3 right-3 z-50 max-h-[calc(100vh-6.5rem)] overflow-y-auto' : 'hidden',
                'lg:flex lg:sticky lg:w-[18%] lg:h-[calc(100vh-3rem)] lg:top-6 '
            ]">
            
            <!-- Desktop Logo (hidden on mobile) -->
            <div class="hidden lg:flex items-center mb-8 p-6 gap-2">
                <img src="/images/logo.png" alt="Logo" class="w-10 h-10 object-contain">
                <h1 class="font-koulen text-3xl text-gray-800 tracking-wide">Printation</h1>
            </div>

            <h2 class="font-bold text-gray-400 mb-2 ml-6 mt-4 lg:mt-0 text-sm uppercase tracking-wider">Menu</h2>

            <div class="flex flex-col">
                <Link href="/admin/upa/dashboard"
                    @click="closeMobileMenu"
                    class="flex gap-3 items-center cursor-pointer p-3 pl-6 w-full transition-colors font-medium border-r-4"
                    :class="$page.url.startsWith('/admin/upa/dashboard') ? 'text-indigo-600 bg-indigo-50 border-indigo-600' : 'text-gray-400 border-transparent hover:bg-gray-50 hover:text-indigo-500'">
                    <LayoutDashboard class="w-5 h-5" />
                    Dashboard
                </Link>

                <Link href="/admin/upa/verify-print"
                    @click="closeMobileMenu"
                    class="flex gap-3 items-center cursor-pointer p-3 pl-6 w-full transition-colors font-medium border-r-4"
                    :class="$page.url.startsWith('/admin/upa/verify-print') ? 'text-indigo-600 bg-indigo-50 border-indigo-600' : 'text-gray-400 border-transparent hover:bg-gray-50 hover:text-indigo-500'">
                    <FileCheck class="w-5 h-5" />
                    <span class="flex-1">Verify Print</span>
                    <span v-if="pendingCount > 0"
                        class="bg-red-500 text-white text-[10px] font-bold px-2 py-0.5 rounded-full mr-2 shadow-sm">{{ pendingCount }}</span>
                </Link>
            </div>

            <Link href="/logout" method="post" as="button"
                class="mt-4 lg:mt-auto text-red-500 w-full p-4 pl-6 flex hover:bg-red-50 transition-colors cursor-pointer rounded-b-xl gap-3 items-center font-medium mb-4 lg:mb-0">
                <LogOut class="w-5 h-5" />
                Logout
            </Link>
        </div>

        <!-- MAIN CONTENT -->
        <div class="flex flex-col flex-1 min-w-0">
            <!-- HEADER (Desktop only - mobile has header in hamburger section) -->
            <div
                class="hidden lg:flex flex-col md:flex-row justify-between items-center mb-4 gap-4 bg-white p-6 rounded-xl shadow-sm shrink-0">
                <div>
                    <slot name="header">
                        <h1 class="text-3xl text-gray-800 font-koulen uppercase tracking-wide">Dashboard</h1>
                    </slot>
                </div>
                <div class="flex items-center gap-3">
                    <img src="/images/upa-pkk-logo.jpg" alt="logo_upa_pkk"
                        class="w-12 h-12 rounded-full border border-gray-100">
                    <div class="flex flex-col">
                        <p class="font-bold text-gray-800">UPA PKK UNTAN</p>
                        <p class="text-sm text-gray-400">Super administrator</p>
                    </div>
                </div>
            </div>

            <!-- MOBILE HEADER INFO -->
            <div class="lg:hidden bg-white p-4 rounded-xl shadow-sm mb-3 flex items-center justify-between">
                <div>
                    <slot name="header">
                        <h1 class="text-xl text-gray-800 font-koulen uppercase tracking-wide">Dashboard</h1>
                    </slot>
                </div>
                <img src="/images/upa-pkk-logo.jpg" alt="logo_upa_pkk"
                    class="w-10 h-10 rounded-full border border-gray-100">
            </div>

            <!-- DYNAMIC CONTENT -->
            <div class="h-full">
                <slot></slot>
            </div>
        </div>
    </div>
</template>
