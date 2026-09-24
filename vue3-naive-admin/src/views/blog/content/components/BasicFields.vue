<script setup lang="ts">
import type { Content, Kind } from "@/service/api/blog";
defineProps<{ kind: Kind; form: Content }>();
const expandedSettings = defineModel<string[]>("expandedSettings", {
  required: true,
});
</script>

<template>
  <section class="form-section">
    <div class="form-section__heading"><h2>基础信息</h2></div>
    <div class="form-section__fields">
      <NGrid cols="1 480:2" :x-gap="16" :y-gap="12">
        <NFormItemGi label="标题 / 名称" :required="kind !== 'comments'">
          <NInput
            v-model:value="form.title"
            :maxlength="200"
            placeholder="请输入标题或名称"
          />
        </NFormItemGi>
        <NFormItemGi label="排序">
          <NInputNumber
            v-model:value="form.sort"
            class="w-full"
            :precision="0"
            :min="-100000"
            :max="100000"
            placeholder="数值越大越靠前"
          />
        </NFormItemGi>
      </NGrid>
      <NFormItem v-if="kind !== 'music'" label="摘要 / 说明">
        <NInput
          v-model:value="form.summary"
          type="textarea"
          :maxlength="2000"
          :autosize="{ minRows: 2, maxRows: 4 }"
          placeholder="公开展示的简介，避免填写私密正文"
        />
      </NFormItem>
      <NCollapse
        v-if="kind !== 'music'"
        v-model:expanded-names="expandedSettings"
      >
        <NCollapseItem title="高级设置" name="advanced">
          <NFormItem label="固定标识">
            <div class="slug-setting">
              <NInput
                v-model:value="form.slug"
                :maxlength="200"
                :placeholder="
                  form.id ? '留空保留原标识' : '留空自动生成，通常无需填写'
                "
              />
              <p v-if="kind === 'documents'" class="slug-setting__hint">
                {{
                  form.id
                    ? "用于文章访问地址。修改后地址会改变，已有链接将失效。"
                    : "用于文章访问地址，可按需自定义；留空由系统自动生成。"
                }}
              </p>
              <p v-else class="slug-setting__hint">
                {{
                  form.id
                    ? "内容的唯一标识，通常无需修改；修改可能影响已有链接或引用。"
                    : "内容的唯一标识，留空由系统自动生成。"
                }}
              </p>
            </div>
          </NFormItem>
        </NCollapseItem>
      </NCollapse>
    </div>
  </section>
</template>
