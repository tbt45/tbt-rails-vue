export interface User {
  id: number
  email: string
  created_at: string
  updated_at: string
}

export const useAuth = () => {
  const user = useState<User | null>('auth.user', () => null)
  const token = useState<string | null>('auth.token', () => null)

  const login = async (userData: User, jwtToken?: string) => {
    user.value = userData
    if (jwtToken) {
      token.value = jwtToken
    }
    if (process.client) {
      localStorage.setItem('auth.user', JSON.stringify(userData))
      if (jwtToken) {
        localStorage.setItem('auth.token', jwtToken)
      }
    }
  }

  const logout = async () => {
    const config = useRuntimeConfig()
    
    try {
      const apiUrl = config.public.apiBaseUrl
      await $fetch(`${apiUrl}/api/v1/auth/sign_out`, {
        method: 'DELETE',
        headers: {
          'Authorization': token.value ? `Bearer ${token.value}` : ''
        }
      })
    } catch (e) {
      console.error('Logout error:', e)
    } finally {
      user.value = null
      token.value = null
      if (process.client) {
        localStorage.removeItem('auth.user')
        localStorage.removeItem('auth.token')
      }
    }
  }

  const checkAuth = async () => {
    if (!user.value && process.client) {
      const storedUser = localStorage.getItem('auth.user')
      const storedToken = localStorage.getItem('auth.token')
      if (storedUser) {
        user.value = JSON.parse(storedUser)
      }
      if (storedToken) {
        token.value = storedToken
      }
    }
  }

  // 初期化時に認証状態を確認
  if (process.client) {
    checkAuth()
  }

  return {
    user: readonly(user),
    token: readonly(token),
    login,
    logout,
    checkAuth
  }
}

