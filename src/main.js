import Vue from "vue";
import ElementUI from "element-ui";
import "element-ui/lib/theme-chalk/index.css";
import App from "./App.vue";
import VueHighlightJS from "vue-highlightjs";

Vue.use(ElementUI);
Vue.use(VueHighlightJS);

new Vue({
    el: "#app",
    render: (h) => h(App),
});
