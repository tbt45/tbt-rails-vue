<template>
  <div class="min-h-screen bg-gray-100 flex items-center justify-center">
    <div class="max-w-md w-full bg-white rounded-lg shadow-lg p-8">
      <h1 class="text-3xl font-bold text-gray-800 mb-4">
        Welcome to TBT Rails
      </h1>
      <p class="text-gray-600 mb-6">
        Rails 8 + Nuxt 3 環境が正常に動作しています！
      </p>
      
      <div class="space-y-4">
        <div class="p-4 bg-blue-50 rounded-lg">
          <h2 class="font-semibold text-blue-900 mb-2">API Status</h2>
          <p v-if="loading" class="text-blue-700">Loading...</p>
          <p v-else-if="error" class="text-red-700">{{ error }}</p>
          <p v-else class="text-green-700">{{ apiStatus }}</p>
        </div>
        
        <button
          @click="checkApi"
          class="w-full bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 px-4 rounded-lg transition"
        >
          API接続を確認
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const config = useRuntimeConfig()
const loading = ref(false)
const error = ref<string | null>(null)
const apiStatus = ref<string>('未確認')

const checkApi = async () => {
  loading.value = true
  error.value = null
  
  try {
    // クライアントサイドでは public.apiBaseUrl を使用
    const apiUrl = process.client 
      ? config.public.apiBaseUrl 
      : config.apiBaseUrl
    const response = await $fetch(`${apiUrl}/api/v1/health`)
    apiStatus.value = response.message || 'Connected!'
  } catch (e: any) {
    error.value = e.message || 'API接続に失敗しました'
    apiStatus.value = '接続エラー'
  } finally {
    loading.value = false
  }
}

// ページ読み込み時に自動でAPI接続を確認
onMounted(() => {
  checkApi()
})
</script>

