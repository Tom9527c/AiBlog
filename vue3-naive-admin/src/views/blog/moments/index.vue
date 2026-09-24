<script setup lang="ts">
import { onMounted } from 'vue';
import { useRouter } from 'vue-router';
defineOptions({ name: 'blog_moments' });
const router = useRouter();
onMounted(() => router.replace('/blog/essays'));
</script>
<template><div>正在前往即刻短文…</div></template>
