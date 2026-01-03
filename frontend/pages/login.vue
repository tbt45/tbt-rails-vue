<template>
  <div class="min-h-screen bg-gray-50 flex items-center justify-center py-12">
    <UContainer class="max-w-md">
      <UCard>
        <template #header>
          <h1 class="text-2xl font-bold text-gray-900 text-center">
            ログイン
          </h1>
        </template>

        <UForm
          :state="state"
          class="space-y-4"
          @submit="onSubmit"
        >
          <UFormGroup
            label="メールアドレス"
            name="email"
            required
            :error="errors.email"
          >
            <UInput
              v-model="state.email"
              type="email"
              placeholder="example@email.com"
              size="lg"
            />
          </UFormGroup>

          <UFormGroup
            label="パスワード"
            name="password"
            required
            :error="errors.password"
          >
            <UInput
              v-model="state.password"
              type="password"
              placeholder="パスワードを入力"
              size="lg"
            />
          </UFormGroup>

          <UAlert
            v-if="error"
            color="red"
            variant="soft"
            :title="error"
            class="mt-4"
          />

          <div class="flex flex-col gap-3 mt-6">
            <UButton
              type="submit"
              color="primary"
              size="lg"
              block
              :loading="loading"
            >
              ログイン
            </UButton>

            <UButton
              to="/"
              color="gray"
              variant="ghost"
              size="lg"
              block
            >
              ホームに戻る
            </UButton>
          </div>
        </UForm>

        <div class="mt-6 text-center">
          <p class="text-sm text-gray-600">
            アカウントをお持ちでない方は
            <NuxtLink to="/signup" class="text-primary-600 hover:underline">
              新規登録
            </NuxtLink>
          </p>
        </div>
      </UCard>
    </UContainer>
  </div>
</template>

<script setup lang="ts">
import type { User } from '~/composables/useAuth'

definePageMeta({
  layout: false
})

const config = useRuntimeConfig()
const { login } = useAuth()
const router = useRouter()

const state = reactive({
  email: '',
  password: ''
})

const errors = ref<Record<string, string>>({})
const loading = ref(false)
const error = ref<string | null>(null)

const onSubmit = async () => {
  loading.value = true
  error.value = null
  errors.value = {}

  try {
    const apiUrl = config.public.apiBaseUrl
    
    // useFetchを使用してヘッダーも取得
    const response = await $fetch.raw<{
      status: { code: number; message: string }
      data: User
    }>(`${apiUrl}/api/v1/auth/sign_in`, {
      method: 'POST',
      body: {
        user: {
          email: state.email,
          password: state.password
        }
      }
    })

    // JWTトークンはレスポンスヘッダーから取得
    const authHeader = response.headers.get('Authorization')
    const jwtToken = authHeader?.replace('Bearer ', '') || null
    const data = await response.json()

    if (data?.status?.code === 200) {
      await login(data.data, jwtToken || undefined)
      await router.push('/')
    }
  } catch (e: any) {
    if (e.data?.errors) {
      errors.value = e.data.errors
    } else {
      error.value = e.data?.status?.message || 'ログインに失敗しました'
    }
  } finally {
    loading.value = false
  }
}
</script>

