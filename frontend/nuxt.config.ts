// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2024-11-01',
  devtools: { enabled: true },
  
  runtimeConfig: {
    // サーバーサイドで使用（Docker内部通信）
    apiBaseUrl: process.env.API_BASE_URL || 'http://backend:3000',
    // クライアントサイドで使用（ブラウザから）
    public: {
      apiBaseUrl: process.env.API_BASE_URL_CLIENT || 'http://localhost:3000'
    }
  },

  css: ['~/assets/css/main.css'],

  modules: [
    '@nuxtjs/tailwindcss'
  ],

  app: {
    head: {
      title: 'TBT Rails App',
      meta: [
        { charset: 'utf-8' },
        { name: 'viewport', content: 'width=device-width, initial-scale=1' }
      ]
    }
  }
})

