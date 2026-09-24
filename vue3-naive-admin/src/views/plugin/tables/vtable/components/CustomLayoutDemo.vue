<script setup lang="tsx">
import { computed, ref } from "vue";
import { VTable } from "@visactor/vue-vtable";
import { useThemeStore } from "@/store/modules/theme";
import {
  ListTable,
  ListColumn,
  Group,
  Image,
  Text,
  Tag,
} from "@visactor/vue-vtable";
import { customListRecords } from "../data";
const themeStore = useThemeStore();
// custom layout list table
const customLayoutListTableRef = ref(null);
const customLayoutListTableOptions = computed(() => {
  return {
    defaultRowHeight: 80,
    theme: themeStore.darkMode ? VTable.themes.DARK : VTable.themes.DEFAULT,
  };
});
const customLayoutListTableRecords = ref(customListRecords);
const customLayoutListTableColumnStyle = ref({
  fontFamily: "Arial",
  fontSize: 12,
  fontWeight: "bold",
});
</script>

<template>
  <NCard
    title="Custom Component"
    :bordered="false"
    class="h-full w-2/3 card-wrapper"
  >
    <ListTable
      ref="customLayoutListTableRef"
      :options="customLayoutListTableOptions"
      :records="customLayoutListTableRecords"
      height="400px"
    >
      <!-- Order Number Column -->
      <ListColumn field="bloggerId" title="Order Number" width="100" />

      <!-- Anchor Nickname Column with Custom Layout -->
      <ListColumn field="bloggerName" title="Anchor Nickname" :width="330">
        <template #customLayout="{ record, height, width }">
          <Group
            :height="height"
            :width="width"
            display="flex"
            flex-direction="row"
            flex-wrap="nowrap"
          >
            <!-- Avatar Group -->
            <Group
              :height="height"
              :width="60"
              display="flex"
              flex-direction="column"
              align-items="center"
              justify-content="space-around"
              fill="red"
              :opacity="0.1"
            >
              <Image
                id="icon0"
                :width="50"
                :height="50"
                :image="record.bloggerAvatar"
                :corner-radius="25"
              />
            </Group>
            <!-- Blogger Info Group -->
            <Group
              :height="height"
              :width="width - 60"
              display="flex"
              flex-direction="column"
              flex-wrap="nowrap"
            >
              <Group
                :height="height / 2"
                :width="width - 60"
                display="flex"
                flex-wrap="wrap"
                align-items="center"
                fill="orange"
                :opacity="0.1"
              >
                <Text
                  :text="record.bloggerName"
                  :font-size="13"
                  font-family="sans-serif"
                  fill="black"
                  :bounds-padding="[0, 0, 0, 10]"
                />
                <Image
                  id="location"
                  image="https://lf9-dp-fe-cms-tos.byteorg.com/obj/bit-cloud/VTable/location.svg"
                  :width="15"
                  :height="15"
                  :bounds-padding="[0, 0, 0, 10]"
                  cursor="pointer"
                />
                <Text
                  :text="record.city"
                  :font-size="11"
                  font-family="sans-serif"
                  fill="#6f7070"
                />
              </Group>
              <!-- Tags Group -->
              <Group
                :height="height / 2"
                :width="width - 60"
                display="flex"
                align-items="center"
                fill="yellow"
                :opacity="0.1"
              >
                <Tag
                  v-for="tag in record?.tags"
                  :key="tag"
                  :text="tag"
                  :text-style="{
                    fontSize: 10,
                    fontFamily: 'sans-serif',
                    fill: 'rgb(51, 101, 238)',
                  }"
                  :panel="{ visible: true, fill: '#f4f4f2', cornerRadius: 5 }"
                  :space="5"
                  :bounds-padding="[0, 0, 0, 5]"
                />
              </Group>
            </Group>
          </Group>
        </template>
      </ListColumn>

      <!-- Other Columns -->
      <ListColumn
        field="fansCount"
        title="Fans Count"
        width="120"
        :field-format="(rec) => rec.fansCount + 'w'"
        :style="customLayoutListTableColumnStyle"
      />
      <ListColumn
        field="worksCount"
        title="Works Count"
        :style="customLayoutListTableColumnStyle"
        width="135"
      />
      <ListColumn
        field="viewCount"
        title="View Count"
        width="120"
        :field-format="(rec) => rec.viewCount + 'w'"
        :style="customLayoutListTableColumnStyle"
      />
    </ListTable>
  </NCard>
</template>
