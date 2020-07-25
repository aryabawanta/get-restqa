<template>
    <div
        :class="[`mb-10 inputcontainer`, level > 0 ? 'noborder' : 'pb-10']"
        :style="`padding-left:${indent}px`"
    >
        <div class="mb-10">
            <h3 v-if="level == 0">{{ inputkey }}</h3>
            <h5 v-else-if="['object', 'array'].includes(type)">{{ inputkey }}</h5>
            <small v-else>{{ inputkey }}</small>
        </div>
        <div class="mb-10">
            <template v-if="type == 'text' || type == 'number'">
                <el-input placeholder="Value" v-model="inputValue"></el-input>
            </template>
            <template v-else-if="type == 'boolean'">
                <el-select v-model="inputValue" placeholder="Value" class="w-full">
                    <el-option label="true" :value="true"></el-option>
                    <el-option label="false" :value="false"></el-option>
                </el-select>
            </template>
            <template v-else-if="type == 'select'">
                <el-select v-model="inputValue" placeholder="Value" class="w-full">
                    <el-option
                        :key="index"
                        v-for="(option, index) in selectOptions"
                        :label="option"
                        :value="option"
                    ></el-option>
                </el-select>
            </template>
            <template v-else-if="['object'].includes(type)">
                <yml-input
                    :key="input.key + '_' + index"
                    v-for="(input, index) in inputValue"
                    :inputkey="input.key"
                    v-model="input.value"
                    :type="input.type"
                    :level="input.level"
                    :select-options="typeof input.selectOptions=='undefined' ? []:input.selectOptions"
                    :conditions="typeof input.conditions=='undefined' ? {}:input.conditions"
                ></yml-input>
            </template>
            <div v-else-if="['array'].includes(type)">
                <div
                    :key="arrayKey"
                    v-for="(arrayInput, arrayKey) in inputValue"
                    :style="
                        `padding-left:10px;display:flex;flex-direction:column;`
                    "
                >
                    <el-divider content-position="left">
                        <small style="font-weight:bold">{{ inputkey }} {{ arrayKey + 1 }}</small>
                    </el-divider>
                    <div class="w-full">
                        <yml-input
                            :key="input.key + '_' + arrayKey + '_' + index"
                            v-for="(input, index) in arrayInput"
                            :inputkey="input.key"
                            v-model="input.value"
                            :type="input.type"
                            :level="input.level"
                            :select-options="typeof input.selectOptions=='undefined' ? []:input.selectOptions"
                            :conditions="typeof input.conditions=='undefined' ? {}:input.conditions"
                        ></yml-input>
                    </div>
                </div>

                <div
                    :style="`margin-left:${level * 10}px`"
                    style="border-bottom:1px solid rgba(0,0,0,0.1)"
                >
                    <el-button
                        @click="addItem"
                        type="primary"
                        icon="el-icon-plus"
                        class="mb-10"
                    >Add {{ inputkey }}</el-button>
                </div>
            </div>

            <template v-if="Object.keys(conditions).length > 0">
                <yml-input
                    :key="condition_input.key + '_conditions_' + conditions_index+'_'+inputValue"
                    v-for="(condition_input, conditions_index) in conditions[inputValue]"
                    :inputkey="condition_input.key"
                    v-model="condition_input.value"
                    :type="condition_input.type"
                    :level="condition_input.level"
                    :select-options="typeof condition_input.selectOptions=='undefined' ? []:condition_input.selectOptions"
                    :conditions="typeof condition_input.conditions=='undefined' ? {}:condition_input.conditions"
                ></yml-input>
            </template>
        </div>
    </div>
</template>
<script>
export default {
    name: "YmlInput",
    props: {
        conditions: {
            type: Object,
        },
        inputkey: {
            default: "",
            type: String,
        },
        level: {
            default: 0,
            type: Number,
        },
        selectOptions: {
            type: Array,
        },
        type: {
            default: "text",
            type: String,
        },
        value: {
            default: "",
        },
    },
    data() {
        return {
            inputValue: "",
            variables: {
                items: {
                    environments: [
                        {
                            key: "name",
                            type: "text",
                            level: this.level + 1,
                            value: "production",
                        },
                        {
                            key: "default",
                            type: "boolean",
                            level: this.level + 1,
                            value: true,
                        },
                        {
                            key: "plugins",
                            type: "array",
                            level: this.level + 1,
                            value: [],
                        },
                        {
                            key: "data",
                            type: "object",
                            level: this.level + 1,
                            value: [
                                {
                                    key: "channel",
                                    type: "select",
                                    level: this.level + 2,
                                    value: "confluence",
                                    selectOptions: [
                                        "confluence",
                                        "google-sheet",
                                        "csv",
                                    ],
                                    conditions: {
                                        confluence: [
                                            {
                                                key: "config",
                                                type: "object",
                                                level: this.level + 2,
                                                value: [
                                                    {
                                                        key: "url",
                                                        type: "text",
                                                        level: this.level + 3,
                                                        value: "",
                                                    },
                                                    {
                                                        key: "space_key",
                                                        type: "text",
                                                        level: this.level + 3,
                                                        value: "SLAF",
                                                    },
                                                    {
                                                        key: "auth",
                                                        type: "object",
                                                        level: this.level + 3,
                                                        value: [
                                                            {
                                                                key: "username",
                                                                type: "text",
                                                                level:
                                                                    this.level +
                                                                    4,
                                                                value: "",
                                                            },
                                                            {
                                                                key: "password",
                                                                type: "text",
                                                                level:
                                                                    this.level +
                                                                    4,
                                                                value: "",
                                                            },
                                                        ],
                                                    },
                                                ],
                                            },
                                        ],
                                        "google-sheet": [
                                            {
                                                key: "config",
                                                type: "object",
                                                level: this.level + 2,
                                                value: [
                                                    {
                                                        key: "id",
                                                        type: "text",
                                                        level: this.level + 3,
                                                        value: "",
                                                    },
                                                    {
                                                        key: "apikey",
                                                        type: "text",
                                                        level: this.level + 3,
                                                        value: "",
                                                    },
                                                ],
                                            },
                                        ],
                                        csv: [
                                            {
                                                key: "config",
                                                type: "object",
                                                level: this.level + 2,
                                                value: [
                                                    {
                                                        key: "folder",
                                                        type: "text",
                                                        level: this.level + 3,
                                                        value: "",
                                                    },
                                                    {
                                                        key: "delimiter",
                                                        type: "text",
                                                        level: this.level + 3,
                                                        value: "",
                                                    },
                                                ],
                                            },
                                        ],
                                    },
                                },
                                {
                                    key: "startSymbol",
                                    type: "text",
                                    level: this.level + 2,
                                    value: "}}",
                                },
                                {
                                    key: "endSymbol",
                                    type: "text",
                                    level: this.level + 2,
                                    value: "}}",
                                },
                            ],
                        },
                        {
                            key: "outputs",
                            type: "array",
                            level: this.level + 1,
                            value: [],
                        },
                    ],
                    outputs: [
                        {
                            key: "type",
                            type: "select",
                            level: this.level + 2,
                            value: "file",
                            selectOptions: [
                                "file",
                                "slack",
                                "http",
                                "elastic-search",
                                "http-html-report",
                            ],
                            conditions: {
                                file: [
                                    {
                                        key: "enabled",
                                        type: "boolean",
                                        level: this.level + 2,
                                        value: false,
                                    },
                                    {
                                        key: "config",
                                        type: "object",
                                        level: this.level + 2,
                                        value: [
                                            {
                                                key: "path",
                                                type: "text",
                                                level: this.level + 3,
                                                value: "",
                                            },
                                        ],
                                    },
                                ],
                                slack: [
                                    {
                                        key: "enabled",
                                        type: "boolean",
                                        level: this.level + 2,
                                        value: true,
                                    },
                                    {
                                        key: "config",
                                        type: "object",
                                        level: this.level + 2,
                                        value: [
                                            {
                                                key: "url",
                                                type: "text",
                                                level: this.level + 3,
                                                value: "",
                                            },
                                            {
                                                key: "showErrors",
                                                type: "boolean",
                                                level: this.level + 3,
                                                value: "",
                                            },
                                            {
                                                key: "onlyFailed",
                                                type: "boolean",
                                                level: this.level + 3,
                                                value: "",
                                            },
                                            {
                                                key: "reportUrl",
                                                type: "text",
                                                level: this.level + 3,
                                                value: "",
                                            },
                                        ],
                                    },
                                ],
                                http: [
                                    {
                                        key: "enabled",
                                        type: "boolean",
                                        level: this.level + 2,
                                        value: true,
                                    },
                                    {
                                        key: "config",
                                        type: "object",
                                        level: this.level + 2,
                                        value: [
                                            {
                                                key: "url",
                                                type: "text",
                                                level: this.level + 3,
                                                value: "",
                                            },
                                            {
                                                key: "method",
                                                type: "select",
                                                level: this.level + 3,
                                                value: "POST",
                                                selectOptions: [
                                                    "POST",
                                                    "PATCH",
                                                    "PUT",
                                                ],
                                            },
                                        ],
                                    },
                                ],
                                "elastic-search": [
                                    {
                                        key: "enabled",
                                        type: "boolean",
                                        level: this.level + 2,
                                        value: true,
                                    },
                                    {
                                        key: "config",
                                        type: "object",
                                        level: this.level + 2,
                                        value: [
                                            {
                                                key: "url",
                                                type: "text",
                                                level: this.level + 3,
                                                value: "",
                                            },
                                        ],
                                    },
                                ],
                                "http-html-report": [
                                    {
                                        key: "enabled",
                                        type: "boolean",
                                        level: this.level + 2,
                                        value: true,
                                    },
                                    {
                                        key: "config",
                                        type: "object",
                                        level: this.level + 2,
                                        value: [
                                            {
                                                key: "url",
                                                type: "text",
                                                level: this.level + 3,
                                                value: "",
                                            },
                                        ],
                                    },
                                ],
                            },
                        },
                    ],
                    plugins: [
                        {
                            key: "name",
                            type: "select",
                            level: this.level + 1,
                            value: "restqapi",
                            selectOptions: ["restqapi", "restqui"],
                            conditions: {
                                restqapi: [
                                    {
                                        key: "config",
                                        type: "object",
                                        level: this.level + 1,
                                        value: [
                                            {
                                                key: "url",
                                                type: "text",
                                                level: this.level + 2,
                                                value: "",
                                            },
                                        ],
                                    },
                                ],
                                restqui: [
                                    {
                                        key: "config",
                                        type: "object",
                                        level: this.level + 1,
                                        value: [
                                            {
                                                key: "url",
                                                type: "text",
                                                level: this.level + 2,
                                                value: "",
                                            },
                                            {
                                                key: "pageObject",
                                                type: "text",
                                                level: this.level + 2,
                                                value: "",
                                            },
                                        ],
                                    },
                                ],
                            },
                        },
                    ],
                },
            },
        };
    },
    watch: {
        inputValue: function (value) {
            if (typeof value == "string") {
                this.$emit("input", value);
            }
        },
    },
    computed: {
        indent() {
            if (
                typeof this.$parent.conditions != "undefined" &&
                Object.keys(this.$parent.conditions).length > 0
            ) {
                return 0;
            }

            return this.level * 10;
        },
    },
    methods: {
        addItem() {
            let variable = JSON.parse(
                JSON.stringify(this.variables.items[this.inputkey])
            );
            this.inputValue.push(variable);
        },
    },
    created() {
        this.inputValue = this.value;
    },
};
</script>
