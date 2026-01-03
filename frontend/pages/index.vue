<template>
  <div class="min-h-screen bg-gray-50">
    <UContainer class="py-12">
      <div class="max-w-2xl mx-auto">
        <UCard>
          <template #header>
            <div class="flex items-center justify-between">
              <h1 class="text-3xl font-bold text-gray-900">
                Welcome to TBT Rails
              </h1>
              <div v-if="!user" class="flex gap-2">
                <UButton
                  to="/login"
                  color="primary"
                  variant="solid"
                >
                  ログイン
                </UButton>
                <UButton
                  to="/signup"
                  color="gray"
                  variant="outline"
                >
                  ユーザー登録
                </UButton>
              </div>
              <UButton
                v-else
                @click="handleLogout"
                color="red"
                variant="outline"
              >
                ログアウト
              </UButton>
            </div>
          </template>

          <div class="space-y-6">
            <div>
              <p class="text-gray-600 mb-4">
                Rails 8 + Nuxt 3 環境が正常に動作しています！
              </p>
            </div>

            <div v-if="user" class="p-4 bg-green-50 rounded-lg border border-green-200">
              <h2 class="font-semibold text-green-900 mb-2">ログイン中</h2>
              <p class="text-green-700">ユーザー: {{ user.email }}</p>
            </div>

            <div class="p-4 bg-blue-50 rounded-lg border border-blue-200">
              <h2 class="font-semibold text-blue-900 mb-2">API Status</h2>
              <div v-if="loading" class="text-blue-700">
                <UIcon name="i-heroicons-arrow-path" class="animate-spin mr-2" />
                Loading...
              </div>
              <p v-else-if="error" class="text-red-700">{{ error }}</p>
              <p v-else class="text-green-700">{{ apiStatus }}</p>
            </div>

            <UButton
              @click="checkApi"
              color="primary"
              variant="outline"
              :loading="loading"
              block
            >
              API接続を確認
            </UButton>
          </div>
        </UCard>
      </div>
    </UContainer>
  </div>
</template>

<script setup lang="ts">
const config = useRuntimeConfig()
const { user, logout } = useAuth()
const loading = ref(false)
const error = ref<string | null>(null)
const apiStatus = ref<string>('未確認')

const checkApi = async () => {
  loading.value = true
  error.value = null
  
  try {
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

const handleLogout = async () => {
  await logout()
  await navigateTo('/')
}

onMounted(() => {
  checkApi()
})
</script>
