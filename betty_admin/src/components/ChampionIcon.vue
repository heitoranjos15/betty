<template>
  <div class="champion-icon" :style="championStyle"></div>
</template>

<script>
export default {
  name: 'ChampionIcon',
  props: {
    row: {
      type: Number,
      required: true,
    },
    col: {
      type: Number,
      required: true,
    },
    spriteSize: {
      type: Number,
      default: 100, // Size of each portrait in pixels
    },
  },
  computed: {
    championStyle() {
      return {
        backgroundImage: `url('https://static.wikia.nocookie.net/lolesports_gamepedia_en/images/b/b5/ChampionSprite.png?version=20250830134005')`, // Adjust path or use CDN
        backgroundPosition: `-${this.col * this.spriteSize}px -${this.row * this.spriteSize}px`,
        width: `${this.spriteSize}px`,
        height: `${this.spriteSize}px`,
      };
    },
  },
};
</script>

<style scoped>
.champion-icon {
  background-size: auto; /* Adjust if sprite sheet size varies */
  background-repeat: no-repeat;
  display: inline-block;
}
</style>
