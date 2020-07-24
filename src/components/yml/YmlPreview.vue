<template>
    <p :style="`margin-left:10px;white-space:normal;`">
        {{ inputkey }}:
        <template v-if="['text', 'number', 'boolean'].includes(type)">{{ value }}</template>
        <template v-else-if="['object'].includes(type)">
            <yml-preview
                :key="index"
                v-for="(input, index) in value"
                :inputkey="input.key"
                v-model="input.value"
                :type="input.type"
                :level="input.level"
            ></yml-preview>
        </template>
        <template v-else-if="['array'].includes(type)">
            <template v-for="(arrayInput, arrayKey) in value">
                <div :key="arrayKey" :style="`padding-left:10px;display:flex;flex-direction:row`">
                    <div>-</div>
                    <div>
                        <yml-preview
                            :key="index"
                            v-for="(input, index) in arrayInput"
                            :inputkey="input.key"
                            v-model="input.value"
                            :type="input.type"
                            :level="input.level"
                        ></yml-preview>
                    </div>
                </div>
            </template>
        </template>
    </p>
</template>
<script>
export default {
    name: "YmlPreview",
    props: {
        inputkey: {
            default: "",
            type: String,
        },
        level: {
            default: 0,
            type: Number,
        },
        type: {
            default: "text",
            type: String,
        },
        value: {
            default: "",
        },
    },
};
</script>
<style>
p {
    margin: 0px;
}
</style>
