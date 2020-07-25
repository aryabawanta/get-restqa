<template>
    <el-row :gutter="20">
        <el-col :span="12">
            <el-card class="card">
                <div slot="header" class="clearfix">
                    <span class="font-bold">Fill inputs to generate yml</span>
                </div>
                <div class="card__content">
                    <yml-input
                        :key="input.key + '_' + index"
                        v-for="(input, index) in inputs"
                        :inputkey="input.key"
                        v-model="input.value"
                        :type="input.type"
                        :level="input.level"
                        :select-options="typeof input.selectOptions=='undefined' ? []:input.selectOptions"
                    ></yml-input>
                </div>
            </el-card>
        </el-col>
        <el-col :span="12">
            <el-card class="card">
                <div slot="header" class="clearfix">
                    <span class="font-bold">Generated yml</span>
                </div>
                <div class="card__content">
                    <div style="background:black;color:white;padding:2px 12px;">
                        <pre v-highlightjs="generatedYmlCode"><code class="hljs javascript"></code></pre>
                    </div>
                </div>
            </el-card>
        </el-col>
    </el-row>
</template>
<script>
import YmlInput from "./YmlInput";
export default {
    name: "Yml",
    components: {
        YmlInput,
    },
    data() {
        return {
            inputs: [
                {
                    key: "version",
                    type: "text",
                    level: 0,
                    value: "0.0.1",
                },
                {
                    key: "metadata",
                    type: "object",
                    level: 0,
                    value: [
                        {
                            key: "name",
                            type: "text",
                            level: 1,
                            value: "",
                        },
                        {
                            key: "description",
                            type: "text",
                            level: 1,
                            value: "",
                        },
                    ],
                },
                {
                    key: "environments",
                    type: "array",
                    level: 0,
                    value: [],
                },
            ],
        };
    },
    computed: {
        generatedYmlCode() {
            var inputs;
            inputs = this.inputs;
            let code = "";
            for (let index = 0; index < inputs.length; index++) {
                const input = inputs[index];
                code += this.getCodeFromInput(input);
            }
            return code;
        },
    },
    methods: {
        getCodeFromInput(input, with_indent = true, increment_indent = 0) {
            let code = "";
            let indent_length = input.level * 2 + 1 + increment_indent;
            if (!with_indent) {
                indent_length = 0;
            }
            let indent = new Array(indent_length).join(" ");
            switch (input.type) {
                case "text":
                case "number":
                case "boolean":
                case "select":
                    code += indent + `${input.key}: ${input.value}\n`;
                    break;
                case "object":
                    code += indent + `${input.key}:\n`;
                    for (const property in input.value) {
                        const value = input.value[property];
                        code += this.getCodeFromInput(
                            value,
                            true,
                            increment_indent
                        );
                    }
                    break;
                case "array":
                    code += indent + `${input.key}:\n`;
                    for (let index = 0; index < input.value.length; index++) {
                        var new_indent_length = (input.level + 1) * 2 + 1;
                        code += new Array(new_indent_length).join(" ") + "- ";
                        var counter = 0;
                        for (const property in input.value[index]) {
                            const value = input.value[index][property];
                            code += this.getCodeFromInput(
                                value,
                                counter == 0 ? false : true,
                                2
                            );
                            counter++;
                        }
                    }
                    break;
            }
            return code;
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
.mt-10 {
    margin-top: 10px;
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
.noborder {
    border: 0px !important;
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
