<template>
  <div class="min-h-screen bg-gray-50 flex items-center justify-center py-12">
    <UContainer class="max-w-md">
      <UCard>
        <template #header>
          <h1 class="text-2xl font-bold text-gray-900 text-center">
            新規登録
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
            help="6文字以上で入力してください"
          >
            <UInput
              v-model="state.password"
              type="password"
              placeholder="パスワードを入力"
              size="lg"
            />
          </UFormGroup>

          <UFormGroup
            label="パスワード（確認）"
            name="password_confirmation"
            required
            :error="errors.password_confirmation"
          >
            <UInput
              v-model="state.password_confirmation"
              type="password"
              placeholder="パスワードを再入力"
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

          <UAlert
            v-if="success"
            color="green"
            variant="soft"
            title="登録が完了しました"
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
              新規登録
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
            既にアカウントをお持ちの方は
            <NuxtLink to="/login" class="text-primary-600 hover:underline">
              ログイン
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
  password: '',
  password_confirmation: ''
})

const errors = ref<Record<string, string>>({})
const loading = ref(false)
const error = ref<string | null>(null)
const success = ref(false)

const validateForm = () => {
  errors.value = {}
  
  if (!state.email) {
    errors.value.email = 'メールアドレスを入力してください'
  } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(state.email)) {
    errors.value.email = '有効なメールアドレスを入力してください'
  }
  
  if (!state.password) {
    errors.value.password = 'パスワードを入力してください'
  } else if (state.password.length < 6) {
    errors.value.password = 'パスワードは6文字以上で入力してください'
  }
  
  if (!state.password_confirmation) {
    errors.value.password_confirmation = 'パスワード（確認）を入力してください'
  } else if (state.password !== state.password_confirmation) {
    errors.value.password_confirmation = 'パスワードが一致しません'
  }
  
  return Object.keys(errors.value).length === 0
}

const onSubmit = async () => {
  if (!validateForm()) {
    return
  }

  loading.value = true
  error.value = null
  success.value = false
  errors.value = {}

  try {
    const apiUrl = config.public.apiBaseUrl
    
    // 新規登録APIを呼び出し
    const { data, response } = await useFetch<{
      status: { code: number; message: string }
      data: User
    }>(`${apiUrl}/api/v1/auth/sign_up`, {
      method: 'POST',
      body: {
        user: {
          email: state.email,
          password: state.password,
          password_confirmation: state.password_confirmation
        }
      }
    })

    // JWTトークンはレスポンスヘッダーから取得
    const authHeader = response.value?.headers.get('Authorization')
    const jwtToken = authHeader?.replace('Bearer ', '') || null

    if (data.value?.status?.code === 200) {
      success.value = true
      await login(data.value.data, jwtToken || undefined)
      
      // 少し待ってからホームにリダイレクト
      setTimeout(async () => {
        await router.push('/')
      }, 1500)
    }
  } catch (e: any) {
    if (e.data?.errors) {
      // Railsのエラーレスポンスを処理
      const railsErrors = e.data.errors
      if (typeof railsErrors === 'object') {
        Object.keys(railsErrors).forEach((key) => {
          const errorMessages = railsErrors[key]
          if (Array.isArray(errorMessages)) {
            errors.value[key] = errorMessages.join(', ')
          } else {
            errors.value[key] = errorMessages
          }
        })
      }
    } else {
      error.value = e.data?.status?.message || '登録に失敗しました'
    }
  } finally {
    loading.value = false
  }
}
</script>

