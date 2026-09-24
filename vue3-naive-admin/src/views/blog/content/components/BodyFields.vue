<script setup lang="ts">
import type { Content, Kind } from "@/service/api/blog";
import MediaField from "../../components/media-field.vue";
import BodyEditor from "../../components/body-editor.vue";
const { form } = defineProps<{ kind: Kind; form: Content }>();
const attachment = defineModel<string>("attachment", { required: true });
function insert() {
  if (!attachment.value) return;
  form.body +=
    form.format === "html"
      ? `\n<img src="${attachment.value}" alt="图片" />`
      : `\n![图片](${attachment.value})\n`;
  attachment.value = "";
}
</script>

<template>
  <section class="form-section form-section--body">
    <div class="form-section__heading"><h2>正文内容</h2></div>
    <div class="form-section__fields">
      <NFormItem v-if="kind !== 'comments'" label="正文格式">
        <NRadioGroup v-model:value="form.format">
          <NRadioButton value="markdown">Markdown</NRadioButton>
          <NRadioButton value="html">富文本 HTML</NRadioButton>
        </NRadioGroup>
      </NFormItem>
      <NFormItem label="正文" :required="kind === 'comments'">
        <NInput
          v-if="kind === 'comments'"
          v-model:value="form.body"
          type="textarea"
          :autosize="{ minRows: 8, maxRows: 18 }"
          placeholder="输入评论正文"
        />
        <div v-else class="body-editor-frame">
          <BodyEditor
            :key="`${form.id}-${form.format}`"
            v-model="form.body"
            :format="form.format"
          />
        </div>
      </NFormItem>
      <NFormItem v-if="kind !== 'comments'" label="插入托管图片">
        <div class="media-insert">
          <MediaField v-model="attachment" />
          <NButton secondary :disabled="!attachment" @click="insert">
            <template #icon><SvgIcon icon="lucide:image-plus" /></template>
            插入正文
          </NButton>
        </div>
      </NFormItem>
    </div>
  </section>
</template>
