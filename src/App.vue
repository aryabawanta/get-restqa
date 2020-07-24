<template>
    <div id="app">
        <yml></yml>
    </div>
</template>

<script>
import Yml from "./components/yml/Yml";
export default {
    components: {
        Yml,
    },
};
</script>

<style>
body {
    background-color: #f4f6fc;
}
#app {
    padding: 32px;
    font-family: Helvetica, sans-serif;
}
</style>
