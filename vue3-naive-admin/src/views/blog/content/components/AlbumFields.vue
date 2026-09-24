<script setup lang="ts">
import type { Content, Kind } from "@/service/api/blog";
import AlbumMediaManager from "../../albums/components/album-media-manager.vue";
defineProps<{ form: Content; saving: boolean }>();
const mediaBusy = defineModel<boolean>("mediaBusy", { required: true });
</script>

<template>
  <section class="form-section">
    <div class="form-section__heading"><h2>相册内容</h2></div>
    <div class="form-section__fields">
      <AlbumMediaManager
        :key="form.id"
        :album-id="form.id"
        :disabled="saving"
        @busy="mediaBusy = $event"
      />
    </div>
  </section>
</template>
