<script setup>
import { useForm, Head } from '@inertiajs/vue3';
import { Eye, EyeOff } from 'lucide-vue-next';
import { ref } from 'vue';

const form = useForm({
    email: '',
    password: '',
});

const showPassword = ref(false);

const submit = () => {
    form.post('/login', {
        onFinish: () => form.reset('password'),
    });
};

const togglePassword = () => {
    showPassword.value = !showPassword.value;
}
</script>

<template>


    <div class="min-h-screen bg-gray-100 flex items-center justify-center p-4">
        <div
            class="bg-white rounded-2xl shadow-2xl w-full max-w-4xl overflow-hidden flex flex-col md:flex-row border border-gray-200">

            <div class="w-full md:w-1/2 p-8 md:p-12">
                <div class="flex items-center justify-center gap-1 mb-6">
                    <img src="/images/logo.png" alt="Logo Print App" class="w-20 h-20 object-contain">

                    <span class="text-5xl font-koulen">PRINTATION</span>
                </div>

                <h1 class="text-3xl font-koulen text-center text-gray-800 mb-8 uppercase tracking-wide">SELAMAT DATANG!
                </h1>

                <form @submit.prevent="submit" class="space-y-5">
                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-2 ml-1">Email</label>
                        <input v-model="form.email" type="email" name="email" placeholder="Masukkan email"
                            class="w-full bg-gray-50 text-gray-800 rounded-lg p-3 border border-gray-200 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 focus:outline-none transition-all"
                            required>
                        <div v-if="form.errors.email" class="text-red-500 text-sm mt-1">{{ form.errors.email }}</div>
                    </div>

                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-2 ml-1">Password</label>
                        <div class="relative">
                            <input v-model="form.password" :type="showPassword ? 'text' : 'password'" name="password"
                                id="password" placeholder="Masukkan password"
                                class="w-full bg-gray-50 text-gray-800 rounded-lg p-3 pr-12 border border-gray-200 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 focus:outline-none transition-all"
                                required>

                            <button type="button" @click="togglePassword"
                                class="absolute right-4 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600 focus:outline-none cursor-pointer">
                                <EyeOff v-if="showPassword" class="w-5 h-5" />
                                <Eye v-else class="w-5 h-5" />
                            </button>
                        </div>
                        <div v-if="form.errors.password" class="text-red-500 text-sm mt-1">{{ form.errors.password }}
                        </div>
                    </div>

                    <button type="submit"
                        class="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-3 rounded-xl transition-all shadow-lg shadow-blue-500/30 mt-4 cursor-pointer disabled:opacity-50"
                        :disabled="form.processing">
                        Masuk
                    </button>
                </form>
            </div>

            <div class="hidden md:flex w-full md:w-1/2 bg-[#015DB4] items-center justify-center p-10 relative">
                <div class="absolute bottom-0 left-0 w-full h-1/2 bg-gradient-to-t from-blue-700/50 to-transparent">
                </div>

                <img src="/images/login-image.png" alt="Login Illustration"
                    class="relative z-10 w-full max-w-sm h-auto object-contain drop-shadow-2xl">
            </div>

        </div>
    </div>
</template>
