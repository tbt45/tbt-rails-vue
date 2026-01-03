export default defineNuxtPlugin(() => {
  const { token } = useAuth()

  // $fetchのデフォルトオプションを設定
  const $api = $fetch.create({
    onRequest({ request, options }) {
      // JWTトークンが存在する場合、Authorizationヘッダーを追加
      if (token.value) {
        options.headers = {
          ...options.headers,
          Authorization: `Bearer ${token.value}`
        }
      }
    },
    onResponseError({ response }) {
      // 401エラーの場合、ログアウト処理
      if (response.status === 401) {
        const { logout } = useAuth()
        logout()
        navigateTo('/login')
      }
    }
  })

  return {
    provide: {
      api: $api
    }
  }
})

