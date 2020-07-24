<template>
    <el-row :gutter="20">
        <el-col :span="12">
            <el-card class="card">
                <div slot="header" class="clearfix">
                    <span class="font-bold">Inputs</span>
                </div>
                <div class="card__content">
                    <div
                        :key="index"
                        v-for="(input, index) in inputs"
                        class="mb-10 pb-10 inputcontainer"
                    >
                        <div class="mb-10">
                            <el-input
                                placeholder="Key name (ex. metadata, environments, etc )"
                                v-model="input.key"
                                class="input-with-select"
                            >
                                <el-select
                                    @change="input.value = ''"
                                    v-model="input.type"
                                    slot="prepend"
                                    placeholder="Value type"
                                >
                                    <el-option
                                        :key="type_index"
                                        v-for="(type,
                                        type_index) in variables.types"
                                        :label="type"
                                        :value="type"
                                    ></el-option>
                                </el-select>
                                <el-button
                                    @click="removeInput(input.index)"
                                    slot="append"
                                    type="danger"
                                    icon="el-icon-close"
                                    class="removeinputbutton"
                                ></el-button>
                            </el-input>
                        </div>
                        <div class="mb-10">
                            <template
                                v-if="
                                    input.type == 'text' ||
                                        input.type == 'number'
                                "
                            >
                                <el-input
                                    placeholder="Value"
                                    v-model="input.value"
                                ></el-input>
                            </template>
                            <template v-else-if="input.type == 'boolean'">
                                <el-select
                                    v-model="input.value"
                                    placeholder="Value"
                                    class="w-full"
                                >
                                    <el-option
                                        label="true"
                                        :value="true"
                                    ></el-option>
                                    <el-option
                                        label="false"
                                        :value="false"
                                    ></el-option>
                                </el-select>
                            </template>
                        </div>
                    </div>
                </div>
                <div class="card__footer">
                    <el-button
                        @click="addInput"
                        type="primary"
                        icon="el-icon-plus"
                        >Add input</el-button
                    >
                </div>
            </el-card>
        </el-col>
        <el-col :span="12">
            <el-card class="card">
                <div slot="header" class="clearfix">
                    <span class="font-bold">Generated yml</span>
                </div>
                <div class="card__content">
                    <code class="hljs yaml">
                        <p
                            style="margin:0px;"
                            :key="index"
                            v-for="(input, index) in inputs"
                        >
                            {{ input.key }}: {{ input.value }}
                        </p>
                    </code>
                </div>
            </el-card>
        </el-col>
    </el-row>
</template>
<script>
export default {
    name: "Yml",
    data() {
        return {
            inputs: [],
            variables: {
                types: ["text", "number", "boolean", "object", "array"],
            },
        };
    },
    methods: {
        addInput() {
            this.inputs.push({
                index: this.inputs.length,
                value: "",
                type: "",
            });
        },
        removeInput(index) {
            this.inputs = this.inputs.filter((input) => {
                return input.index != index;
            });
        },
    },
};
</script>
<style>
.card {
}
.card__content {
}
.card__footer {
    margin-top: 32px;
}
.mb-10 {
    margin-bottom: 10px;
}
.pb-10 {
    padding-bottom: 10px;
}
.inputcontainer {
    border-bottom: 1px solid rgba(0, 0, 0, 0.2);
}
.el-select .el-input {
    width: 150px;
}
.input-with-select .el-input-group__prepend {
    background-color: #fff;
}
.removeinputbutton {
    color: #fff !important;
    background-color: #f56c6c !important;
    border-color: #f56c6c !important;
}
.w-full {
    width: 100%;
}
.el-select.w-full > .el-input {
    width: 100%;
}
</style>
