<template>
  <v-app>
    <v-main>
      <v-container>
        <v-row>
          <!-- Home Team -->
          <v-col cols="12" md="6">
            <v-card class="mb-4">
              <v-card-title>Home Team Matches</v-card-title>
              <v-card-text>
                <v-data-table
                  :headers="headers"
                  :items="homeMatches"
                  item-key="id"
                  class="elevation-1"
                  hide-default-footer
                >
                  <template #item.won="{ item }">
                    <v-chip :color="item.won ? 'green' : 'red'" dark>
                      {{ item.won ? 'Win' : 'Loss' }}
                    </v-chip>
                  </template>
                </v-data-table>
              </v-card-text>
            </v-card>
          </v-col>
          <!-- Away Team -->
          <v-col cols="12" md="6">
            <v-card class="mb-4">
              <v-card-title>Away Team Matches</v-card-title>
              <v-card-text>
                <v-data-table
                  :headers="headers"
                  :items="awayMatches"
                  item-key="id"
                  class="elevation-1"
                  hide-default-footer
                >
                  <template #item.won="{ item }">
                    <v-chip :color="item.won ? 'green' : 'red'" dark>
                      {{ item.won ? 'Win' : 'Loss' }}
                    </v-chip>
                  </template>
                </v-data-table>
              </v-card-text>
            </v-card>
          </v-col>
        </v-row>
      </v-container>
    </v-main>
  </v-app>
</template>

<script>
export default {
  name: 'App',
  data() {
    return {
      headers: [
        { text: 'Event', value: 'event' },
        { text: 'Patch', value: 'patch' },
        { text: 'Duration', value: 'duration' },
        { text: 'Won', value: 'won' },
      ],
      homeMatches: [
        { id: 1, event: 'TeamA x TeamC', patch: '13.1', duration: '35:12', won: true },
        { id: 2, event: 'TeamA x TeamD', patch: '13.2', duration: '28:45', won: false },
      ],
      awayMatches: [
        { id: 1, event: 'TeamB x TeamC', patch: '13.1', duration: '32:10', won: false },
        { id: 2, event: 'TeamB x TeamA', patch: '13.2', duration: '30:22', won: true },
      ],
    };
  },
};
</script>
