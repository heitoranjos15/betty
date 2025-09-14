<template>
  <v-app>
    <v-main>
      <v-container fluid>
        <v-row>
          <!-- Home Team -->
          <v-col cols="12" md="12">
            <v-card class="mb-4" flat>
              <v-card-title class="text-h5 font-weight-bold">
                Home Team Matches
                <v-spacer></v-spacer>
                <v-row>
                  <v-autocomplete
                    v-model="selectedHomeTeam"
                    :items="teamOptions"
                    item-title="name"
                    item-value="externalId"
                    label="Select Home Team"
                    clearable
                    hide-details
                    class="ml-4"
                    style="max-width: 300px;"
                    @update:modelValue="searchHomeTeam"
                    solo
                    dense
                  ></v-autocomplete>
                  <v-autocomplete
                    v-model="selectedChampionHomeTeam"
                    :items="championOptions"
                    item-title="name"
                    item-value="id"
                    label="Filter by Champion"
                    clearable
                    hide-details
                    class="ml-4"
                    style="max-width: 300px;"
                    solo
                    id="champion-select"
                    @update:modelValue="filterByChampion"
                    ></v-autocomplete>
                </v-row>
              </v-card-title>
              <v-card-text>
                <v-data-table
                  :headers="headers"
                  :items="homeMatches"
                  item-key="id"
                  class="elevation-1"
                  dense
                  fixed-header
                  :loading="homeLoading"
                  show-header
                  v-model:expanded="expandedHome"
                  show-expand
                  style="width: 100%;"
                  :items-per-page="itemsPerPageHome"
                  :footer-props="{
                    'items-per-page-options': [10, 15, 20]
                  }">

                  <!-- eslint-disable-next-line vue/valid-v-slot -->
                  <template v-slot:item.side="{ item }">
                    <v-chip :color="item.side === 'red' ? 'red darken-2' : 'blue darken-2'" dark small>
                      <span class="text-capitalize">{{ item.side }}</span>
                    </v-chip>
                  </template>
                  <!-- TODO: Fix the background color issue for red side champions -->
                  <!-- eslint-disable-next-line vue/valid-v-slot -->
                  <template v-slot:item.redSideChampions="{ item }">
                    <!-- <v-chip :color="item.side === 'red' ? 'white darken-3': ''" dark small class="mb-1"> -->
                      <div class="d-flex">
                        <div
                          v-for="(champion, index) in item.redSideChampions"
                          :key="index"
                          class="mr-1"
                        >
                          <img
                            :src="champion.icon"
                            :alt="champion.name"
                            width="24"
                            height="24"
                            :title="champion.name"
                          />

                        </div>
                      </div>
                    <!-- </v-chip> -->
                  </template>
                  <!-- eslint-disable-next-line vue/valid-v-slot -->
                  <template v-slot:item.blueSideChampions="{ item }">
                    <div class="d-flex">
                      <div
                        v-for="(champion, index) in item.blueSideChampions"
                        :key="index"
                        class="mr-1"
                      >
                        <img
                          :src="champion.icon"
                          :alt="champion.name"
                          width="24"
                          height="24"
                          :title="champion.name"
                        />
                      </div>
                    </div>
                  </template>
                  <!-- eslint-disable-next-line vue/valid-v-slot -->
                  <template #item.won="{ item }">
                    <v-chip :color="item.won ? 'green' : 'red'" dark small>
                      {{ item.won ? 'Win' : 'Loss' }}
                    </v-chip>
                  </template>
                  <template #no-data>
                    <span>No matches available. Select a team to view matches.</span>
                  </template>
                  <template #expanded-row="{ columns, item }">
                    <tr>
                      <td :colspan="columns.length">
                        <v-container fluid class="pa-4">
                          <v-tabs v-model="activeTab" color="primary" class="elevation-1">
                            <v-tab value="team-details">Team Details</v-tab>
                          </v-tabs>
                          <v-window v-model="activeTab">
                            <v-window-item value="team-details" justify="center">
                              <!-- Team Details Table -->
                              <v-card flat class="mt-4">
                                <v-card-title>Team Statistics</v-card-title>
                                <v-col cols="12" md="10">
                                  <v-data-table
                                    :headers="teamHeaders"
                                    :items="mapTeamGameDetails(item)"
                                    item-key="teamName"
                                    class="elevation-1"
                                    hide-default-footer
                                    dense
                                  ></v-data-table>
                                </v-col>
                              </v-card>
                              <!-- Player Tables (Side by Side) -->
                              <v-row class="mt-4" justify="space-between">
                                <v-col cols="12" md="6">
                                  <v-card flat>
                                    <v-card-title>{{ item.redSide.code }}</v-card-title>
                                    <v-data-table
                                      :headers="playerHeaders"
                                      :items="item.redSidePlayers"
                                      item-key="name"
                                      class="elevation-1"
                                      hide-default-footer
                                      dense
                                      style="width: 100%;"
                                    >
<!-- eslint-disable-next-line vue/valid-v-slot -->
                                      <template #item.players_champ="{ item }">
                                        <div class="d-flex align-center">
                                          <img
                                            :src="item.championIcon || 'https://via.placeholder.com/24'"
                                            alt="Champion Icon"
                                            width="24"
                                            height="24"
                                            class="mr-2"
                                          />
                                          <span>{{ item.champion }}</span>
                                        </div>
                                      </template>
<!-- eslint-disable-next-line vue/valid-v-slot -->
                                      <template #item.gold_diff="{ item }">
                                        <span :class="item.gold_diff > 0 ? 'green--text' : 'red--text'">
                                          {{ item.gold_diff.toFixed(0) }}
                                        </span>
                                      </template>
                                    </v-data-table>
                                  </v-card>
                                </v-col>
                                <v-col cols="12" md="6">
                                  <v-card flat>
                                    <v-card-title>{{ item.blueSide.code }}</v-card-title>
                                    <v-data-table
                                      :headers="playerHeaders"
                                      :items="item.blueSidePlayers"
                                      item-key="name"
                                      class="elevation-1"
                                      hide-default-footer
                                      dense
                                      style="width: 100%;"
                                    >
<!-- eslint-disable-next-line vue/valid-v-slot -->
                                      <template #item.players_champ="{ item }">
                                        <div class="d-flex align-center">
                                          <img
                                            :src="item.championIcon || 'https://via.placeholder.com/24'"
                                            alt="Champion Icon"
                                            width="24"
                                            height="24"
                                            class="mr-2"
                                          />
                                          <span>{{ item.champion }}</span>
                                        </div>
                                      </template>
<!-- eslint-disable-next-line vue/valid-v-slot -->
                                      <template #item.gold_diff="{ item }">
                                        <span :class="item.gold_diff > 0 ? 'green--text' : 'red--text'">
                                          {{ item.gold_diff.toFixed(0) }}
                                        </span>
                                      </template>
                                    </v-data-table>
                                  </v-card>
                                </v-col>
                            </v-row>
                            </v-window-item>
                          </v-window>
                        </v-container>
                      </td>
                    </tr>
                  </template>
                </v-data-table>
              </v-card-text>
            </v-card>
          </v-col>
          <!-- Away Team -->
          <v-col cols="12" md="12">
            <v-card class="mb-4" flat>
              <v-card-title class="text-h5 font-weight-bold">
                Away Team Matches
                <v-spacer></v-spacer>
                <v-autocomplete
                  v-model="selectedAwayTeam"
                  :items="teamOptions"
                  item-title="name"
                  item-value="externalId"
                  label="Select Away Team"
                  clearable
                  hide-details
                  class="ml-4"
                  style="max-width: 300px;"
                  @update:modelValue="searchAwayTeam"
                  solo
                  dense
                ></v-autocomplete>

              </v-card-title>
              <v-card-text>
                <v-data-table
                  :headers="headers"
                  :items="awayMatches"
                  item-key="id"
                  class="elevation-1"
                  dense
                  :loading="awayLoading"
                  show-header
                  :expanded="expandedAway"
                  show-expand
                  style="width: 100%;"
                  :items-per-page="itemsPerPageAway"
                  :footer-props="{
                    'items-per-page-options': [10, 15, 20]
                  }"
                >
                  <!-- eslint-disable-next-line vue/valid-v-slot -->
                  <template #item.won="{ item }">
                    <v-chip :color="item.won ? 'green' : 'red'" dark small>
                      {{ item.won ? 'Win' : 'Loss' }}
                    </v-chip>
                  </template>

                  <!-- eslint-disable-next-line vue/valid-v-slot -->
                  <template v-slot:item.side="{ item }">
                    <v-chip :color="item.side === 'red' ? 'red darken-2' : 'blue darken-2'" dark small>
                      <span class="text-capitalize">{{ item.side }}</span>
                    </v-chip>
                  </template>

                  <!-- TODO: Fix the background color issue for red side champions -->
                  <!-- eslint-disable-next-line vue/valid-v-slot -->
                  <template v-slot:item.redSideChampions="{ item }">
                    <!-- <v-chip :color="item.side === 'red' ? 'white darken-3': ''" dark small class="mb-1"> -->
                      <div class="d-flex">
                        <div
                          v-for="(champion, index) in item.redSideChampions"
                          :key="index"
                          class="mr-1"
                        >
                          <img
                            :src="champion.icon"
                            :alt="champion.name"
                            width="24"
                            height="24"
                            :title="champion.name"
                          />

                        </div>
                      </div>
                    <!-- </v-chip> -->
                  </template>
                  <!-- eslint-disable-next-line vue/valid-v-slot -->
                  <template v-slot:item.blueSideChampions="{ item }">
                    <div class="d-flex">
                      <div
                        v-for="(champion, index) in item.blueSideChampions"
                        :key="index"
                        class="mr-1"
                      >
                        <img
                          :src="champion.icon"
                          :alt="champion.name"
                          width="24"
                          height="24"
                          :title="champion.name"
                        />
                      </div>
                    </div>
                  </template>
                  <template #no-data>
                    <span>No matches available. Select a team to view matches.</span>
                  </template>
                  <template #expanded-row="{ columns, item }">
                    <tr>
                      <td :colspan="columns.length">
                        <v-container fluid class="pa-4">
                          <v-tabs v-model="activeTab" color="primary" class="elevation-1">
                            <v-tab value="team-details">Team Details</v-tab>
                          </v-tabs>
                          <v-window v-model="activeTab">
                            <v-window-item value="team-details">
                              <!-- Team Details Table -->
                              <v-card flat class="mt-4">
                                <v-card-title>Team Statistics</v-card-title>
                                <v-data-table
                                  :headers="teamHeaders"
                                  :items="mapTeamGameDetails(item)"
                                  item-key="teamName"
                                  class="elevation-1"
                                  hide-default-footer
                                  dense
                                  style="width: 100%;"
                                ></v-data-table>
                              </v-card>
                              <v-row class="mt-4">
                                <v-col cols="12" md="6">
                                  <v-card flat>
                                    <v-card-title>{{ item.redSide.code }}</v-card-title>
                                    <v-data-table
                                      :headers="playerHeaders"
                                      :items="item.redSidePlayers"
                                      item-key="name"
                                      class="elevation-1"
                                      hide-default-footer
                                      dense
                                      style="width: 100%;"
                                    >
<!-- eslint-disable-next-line vue/valid-v-slot -->
                                      <template #item.players_champ="{ item }">
                                        <div class="d-flex align-center">
                                          <img
                                            :src="item.championIcon || 'https://via.placeholder.com/24'"
                                            alt="Champion Icon"
                                            width="24"
                                            height="24"
                                            class="mr-2"
                                          />
                                          <span>{{ item.champion }}</span>
                                        </div>
                                      </template>
<!-- eslint-disable-next-line vue/valid-v-slot -->
                                      <template #item.gold_diff="{ item }">
                                        <span :class="item.gold_diff > 0 ? 'green--text' : 'red--text'">
                                          {{ item.gold_diff.toFixed(0) }}
                                        </span>
                                      </template>
                                    </v-data-table>
                                  </v-card>
                                </v-col>
                                <v-col cols="12" md="6">
                                  <v-card flat>
                                    <v-card-title>{{ item.blueSide.code }}</v-card-title>
                                    <v-data-table
                                      :headers="playerHeaders"
                                      :items="item.blueSidePlayers"
                                      item-key="name"
                                      class="elevation-1"
                                      hide-default-footer
                                      dense
                                      style="width: 100%;"
                                    >
<!-- eslint-disable-next-line vue/valid-v-slot -->
                                      <template #item.players_champ="{ item }">
                                        <div class="d-flex align-center">
                                          <img
                                            :src="item.championIcon || 'https://via.placeholder.com/24'"
                                            alt="Champion Icon"
                                            width="24"
                                            height="24"
                                            class="mr-2"
                                          />
                                          <span>{{ item.champion }}</span>
                                        </div>
                                      </template>
<!-- eslint-disable-next-line vue/valid-v-slot -->
                                      <template #item.gold_diff="{ item }">
                                        <span :class="item.gold_diff > 0 ? 'green--text' : 'red--text'">
                                          {{ item.gold_diff.toFixed(0) }}
                                        </span>
                                      </template>
                                    </v-data-table>
                                  </v-card>
                                </v-col>
                              </v-row>
                            </v-window-item>
                          </v-window>
                        </v-container>
                      </td>
                    </tr>
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
import { computed, watchEffect} from 'vue';
import { provideApolloClient, useQuery } from '@vue/apollo-composable';
import { apolloClient } from './plugins/apollo';
import { GET_GAMES_BY_TEAM_EXTERNAL_ID, GET_TEAMS } from './graphql/queries';

export default {
  name: 'App',
  setup() {
    const { result, error } = useQuery(GET_TEAMS, {});
    if (error.value) {
      console.error('Error fetching teams:', error.value);
      return;
    }
    const teamOptions = computed(() =>
      result.value?.teams?.map(team => ({
        name: team.name,
        externalId: team.externalId,
      })) || []
    );

    const championOptions = [
      {
        id: 'Aatrox',
        name: 'Aatrox',
      },
      {
        id: 'Ahri',
        name: 'Ahri',
      },
      {
        id: 'Akali',
        name: 'Akali',
      },
      {
        id: 'Alistar',
        name: 'Alistar',
      },
      {
        id: 'Amumu',
        name: 'Amumu',
      },
      {
        id: 'Anivia',
        name: 'Anivia',
      },
      {
        id: 'Annie',
        name: 'Annie',
      },
      {
        id: 'Aphelios',
        name: 'Aphelios',
      },
      {
        id: 'Ashe',
        name: 'Ashe',
      },
      {
        id: 'AurelionSol',
        name: 'Aurelion Sol',
      },
      {
        id: 'Azir',
        name: 'Azir',
      },
      {
        id: 'Bard',
        name: 'Bard',
      },
      {
        id: 'Blitzcrank',
        name: 'Blitzcrank',
      },
      {
        id: 'Brand',
        name: 'Brand',
      },
      {
        id: 'Braum',
        name: 'Braum',
      },
      {
        id: 'Caitlyn',
        name: 'Caitlyn',
      },
      {
        id: 'Camille',
        name: 'Camille',
      },
      {
        id: 'Cassiopeia',
        name: 'Cassiopeia',
      },
      {
        id: 'Chogath',
        name: 'Cho\'Gath',
      },
      {
        id: 'Corki',
        name: 'Corki',
      },
      {
        id: 'Darius',
        name: 'Darius',
      },
      {
        id: 'Diana',
        name: 'Diana',
      },
      {
        id: 'Draven',
        name: 'Draven',
      },
      {
        id: 'DrMundo',
        name: 'Dr. Mundo',
      },
      {
        id: 'Ekko',
        name: 'Ekko',
      },
      {
        id: 'Elise',
        name: 'Elise',
      },
      {
        id: 'Evelynn',
        name: 'Evelynn',
      },
      {
        id: 'Ezreal',
        name: 'Ezreal',
      },
      {
        id: 'Fiddlesticks',
        name: 'Fiddlesticks',
      },
      {
        id: 'Fiora',
        name: 'Fiora',
      },
      {
        id: 'Fizz',
        name: 'Fizz',
      },
      {
        id: 'Galio',
        name: 'Galio',
      },
      {
        id: 'Gangplank',
        name: 'Gangplank',
      },
      {
        id: 'Garen',
        name: 'Garen',
      },
      {
        id: 'Gnar',
        name: 'Gnar',
      },
      {
        id: 'Gragas',
        name: 'Gragas',
      },
      {
        id: 'Graves',
        name: 'Graves',
      },
      {
        id: 'Hecarim',
        name: 'Hecarim',
      },
      {
        id: 'Heimerdinger',
        name: 'Heimerdinger',
      },
      {
        id: 'Illaoi',
        name: 'Illaoi',
      },
      {
        id: 'Irelia',
        name: 'Irelia',
      },
      {
        id: 'Ivern',
        name: 'Ivern',
      },
      {
        id: 'Janna',
        name: 'Janna',
      },
      {
        id: 'JarvanIV',
        name: 'Jarvan IV',
      },
      {
        id: 'Jax',
        name: 'Jax',
      },
      {
        id: 'Jayce',
        name: 'Jayce',
      },
      {
        id: 'Jhin',
        name: 'Jhin',
      },
      {
        id: 'Jinx',
        name: 'Jinx',
      },
      {
        id: 'KaiSa',
        name: 'Kai\'Sa',
      },
      {
        id: 'Kalista',
        name: 'Kalista',
      },
      {
        id: 'Karma',
        name: 'Karma',
      },
      {
        id: 'Karthus',
        name: 'Karthus',
      },
      {
        id: 'Kassadin',
        name: 'Kassadin',
      },
      {
        id: 'Katarina',
        name: 'Katarina',
      },
      {
        id: 'Kayle',
        name: 'Kayle',
      },
      {
        id: 'Kayn',
        name: 'Kayn',
      },
      {
        id: 'Kennen',
        name: 'Kennen',
      },
      {
        id: "Khazix",
        name: "Kha'Zix",
      },
      {
        id: 'Kindred',
        name: 'Kindred',
      },
      {
        id: 'Kled',
        name: 'Kled',
      },
      {
        id: "KogMaw",
        name: "Kog'Maw",
      },
      {
        id: "Leblanc",
        name: "LeBlanc",
      },
      {
        id: "LeeSin",
        name: "Lee Sin",
      },
      {
        id: "Leona",
        name: "Leona",
      },
      {
        id: "Lillia",
        name: "Lillia",
      },
      {
        id: "Lissandra",
        name: "Lissandra",
      },
      {
        id: "Lucian",
        name: "Lucian",
      },
      {
        id: "Lulu",
        name: "Lulu",
      },
      {
        id: "Lux",
        name: "Lux",
      },
      {
        id: "Malphite",
        name: "Malphite",
      },
      {
        id: "Malzahar",
        name: "Malzahar",
      },
      {
        id: "Maokai",
        name: "Maokai",
      },
      {
        id: "MasterYi",
        name: "Master Yi",
      },
      {
        id: "MissFortune",
        name: "Miss Fortune",
      },
      {
        id: "Mordekaiser",
        name: "Mordekaiser",
      },
      {
        id: "Morgana",
        name: "Morgana",
      },
      {
        id: "Nami",
        name: "Nami",
      },
      {
        id: "Nasus",
        name: "Nasus",
      },
      {
        id: "Nautilus",
        name: "Nautilus",
      },
      {
        id: "Neeko",
        name: "Neeko",
      },
      {
        id: "Nidalee",
        name: "Nidalee",
      },
      {
        id: "Nocturne",
        name: "Nocturne",
      },
      {
        id: "NunuWillump",
        name: "Nunu & Willump",
      },
      {
        id: "Olaf",
        name: "Olaf",
      },
      {
        id: "Orianna",
        name: "Orianna",
      },
      {
        id: "Ornn",
        name: "Ornn",
      },
      {
        id: 'Pantheon',
        name: 'Pantheon',
      },
      {
        id: 'Poppy',
        name: 'Poppy',
      },
      {
        id: 'Pyke',
        name: 'Pyke',
      },
      {
        id: 'Qiyana',
        name: 'Qiyana',
      },
      {
        id: 'Quinn',
        name: 'Quinn',
      },
      {
        id: 'Rakan',
        name: 'Rakan',
      },
      {
        id: 'Rammus',
        name: 'Rammus',
      },
      {
        id: 'RekSai',
        name: "Rek'Sai",
      },
      {
        id: 'Renekton',
        name: 'Renekton',
      },
      {
        id: 'Rengar',
        name: 'Rengar',
      },
      {
        id: 'Riven',
        name: 'Riven',
      },
      {
        id: 'Rumble',
        name: 'Rumble',
      },
      {
        id: 'Ryze',
        name: 'Ryze',
      },
      {
        id: 'Samira',
        name: 'Samira',
      },
      {
        id: 'Sejuani',
        name: 'Sejuani',
      },
      {
        id: 'Senna',
        name: 'Senna',
      },
      {
        id: 'Seraphine',
        name: 'Seraphine',
      },
      {
        id: 'Sett',
        name: 'Sett',
      },
      {
        id: 'Shaco',
        name: 'Shaco',
      },
      {
        id: 'Shen',
        name: 'Shen',
      },
      {
        id: 'Shyvana',
        name: 'Shyvana',
      },
      {
        id: 'Singed',
        name: 'Singed',
      },
      {
        id: 'Sion',
        name: 'Sion',
      },
      {
        id: 'Sivir',
        name: 'Sivir',
      },
      {
        id: 'Skarner',
        name: 'Skarner',
      },
      {
        id: 'Sona',
        name: 'Sona',
      },
      {
        id: 'Soraka',
        name: 'Soraka',
      },
      {
        id: 'Swain',
        name: 'Swain',
      },
      {
        id: 'Sylas',
        name: 'Sylas',
      },
      {
        id: 'Syndra',
        name: 'Syndra',
      },
      {
        id: "TahmKench",
        name: "Tahm Kench",
      },
      {
        id: "Taliyah",
        name: "Taliyah",
      },
      {
        id: "Talon",
        name: "Talon",
      },
      {
        id: "Taric",
        name: "Taric",
      },
      {
        id: "Teemo",
        name: "Teemo",
      },
      {
        id: "Thresh",
        name: "Thresh",
      },
      {
        id: "Tristana",
        name: "Tristana",
      },
      {
        id: "Trundle",
        name: "Trundle",
      },
      {
        id: "Tryndamere",
        name: "Tryndamere",
      },
      {
        id: "TwistedFate",
        name: "Twisted Fate",
      },
      {
        id: "Twitch",
        name: "Twitch",
      },
      {
        id: "Udyr",
        name: "Udyr",
      },
      {
        id: "Urgot",
        name: "Urgot",
      },
      {
        id: "Varus",
        name: "Varus",
      },
      {
        id: "Vayne",
        name: "Vayne",
      },
      {
        id: "Veigar",
        name: "Veigar",
      },
      {
        id: "Velkoz",
        name: "Vel'Koz",
      },
      {
        id: "Vi",
        name: "Vi",
      },
      {
        id: "Viktor",
        name: "Viktor",
      },
      {
        id: "Vladimir",
        name: "Vladimir",
      },
      {
        id: "Volibear",
        name: "Volibear",
      },
      {
        id: "Warwick",
        name: "Warwick",
      },
      {
        id: "Wukong",
        name: "Wukong",
      },
      {
        id: 'Xayah',
        name: 'Xayah',
      },
      {
        id: 'Xerath',
        name: 'Xerath',
      },
      {
        id: 'XinZhao',
        name: 'Xin Zhao',
      },
      {
        id: 'Yasuo',
        name: 'Yasuo',
      },
      {
        id: 'Yone',
        name: 'Yone',
      },
      {
        id: 'Yorick',
        name: 'Yorick',
      },
      {
        id: 'Yuumi',
        name: 'Yuumi',
      },
      {
        id: 'Zac',
        name: 'Zac',
      },
      {
        id: 'Zed',
        name: 'Zed',
      },
      {
        id: 'Ziggs',
        name: 'Ziggs',
      },
      {
        id: 'Zilean',
        name: 'Zilean',
      },
      {
        id: 'Zoe',
        name: 'Zoe',
      },
      {
        id: 'Zyra',
        name: 'Zyra',
      },
  ]
    return {
      teamOptions,
      championOptions,
    };
  },
  data() {
    return {
      headers: [
        { title: 'Opponent', key: 'opponent', width: '20%' },
        { title: 'Date', key: 'date', width: '15%' },
        { title: 'Patch', key: 'patch', width: '10%' },
        { title: 'Side', key: 'side', width: '10%' },
        { title: 'Red', key: 'redSideChampions', width: '15%', sortable: false },
        { title: 'Blue', key: 'blueSideChampions', width: '15%', sortable: false },
        { title: 'Duration', key: 'duration', width: '15%' },
        { title: 'Towers', key: 'towers', width: '10%' },
        { title: 'Won', key: 'won', width: '10%' },
      ],
      teamHeaders: [
        { title: 'Team', key: 'teamName', sortable: true, width: '20%' },
        { title: 'Kills', key: 'kills', sortable: true, width: '15%' },
        { title: 'Gold', key: 'gold', sortable: true, width: '15%' },
        { title: 'Towers', key: 'towers', sortable: true, width: '15%' },
        { title: 'Drakes', key: 'drakes', sortable: true, width: '35%' },
      ],
      playerHeaders: [
        { title: 'Team', key: 'team_code', sortable: true, width: '15%' },
        { title: 'Champion', key: 'players_champ', sortable: true, width: '20%' },
        { title: 'Gold Diff', key: 'gold_diff', sortable: true, width: '15%' },
        { title: 'Total Gold', key: 'total_gold', sortable: true, width: '15%' },
        { title: 'KDA', key: 'kda', sortable: true, width: '15%' },
        { title: 'Farm', key: 'farm', sortable: true, width: '20%' },
      ],
      homeMatches: [],
      awayMatches: [],
      selectedHomeTeam: null,
      selectedAwayTeam: null,
      selectedChampionHomeTeam: null,
      homeTeamSearch: '',
      awayTeamSearch: '',
      homeTeamGames: [],
      awayTeamGames: [],
      expandedHome: [],
      expandedAway: [],
      activeTab: 'team-details',
      homeLoading: false,
      awayLoading: false,
      homeTeamGameDetail: {},
      awayTeamGameDetail: {},
      playersGameDetail: {},
      itemsPerPageHome: 10,
      itemsPerPageAway: 10,
    };
  },
  methods: {
    mapTeamGames(teamGames, externalId) {
      if (!teamGames) {
        console.warn('No team games provided for mapping:', teamGames);
        return [];
      }
      return teamGames.map(game => {
        const gameData = game?.gameData;
        if (!gameData || !gameData.teams || gameData.teams.length < 2) {
          console.warn('Invalid game data:', gameData);
          return;
        }
        const teamDetails = gameData.teams.find(team => team.externalId === externalId);
        const opponentDetails = gameData.teams.find(team => team.externalId !== externalId);
        const gameChampions = game.playerData.map(player => ({ name: player.champion
          , icon: `https://ddragon.leagueoflegends.com/cdn/15.18.1/img/champion/${player.champion}.png` }));
        const redSide = gameData.teams[0].side === 'red' ? gameData.teams[0] : gameData.teams[1];
        const blueSide = gameData.teams[0].side === 'blue' ? gameData.teams[0] : gameData.teams[1];

        const redSidePlayers = [];
        const blueSidePlayers = [];
        game.playerData.forEach((player, index) => {
          const opponentIndex = index < 5 ? index + 5 : index - 5;
          const opponent = game.playerData[opponentIndex];
          const goldDiff = opponent.totalGoldEarned - player.totalGoldEarned;

          const championIcon = player.championIconUrl || `https://ddragon.leagueoflegends.com/cdn/15.18.1/img/champion/${player.champion}.png`;
          const playerTeam = index < 5 ? 'redSide' : 'blueSide';
          const playerData = {
              ...player,
              team_code: playerTeam === 'redSide' ? redSide.code.trim() : blueSide.code.trim(),
              gold_diff: goldDiff,
              total_gold: player.totalGoldEarned || 0,
              farm: player.creepScore || 0,
              kda: `${player.kills}/${player.deaths}/${player.assists}`,
              side: playerTeam,
              championIcon,
            };

          if (playerTeam === 'redSide') redSidePlayers.push(playerData);
          else blueSidePlayers.push(playerData);
        });

        return {
          id: game.externalId,
          side:teamDetails.side,
          redSideChampions: gameChampions.slice(0, 5),
          blueSideChampions: gameChampions.slice(5, 10),
          opponent: opponentDetails.code.trim(),
          date: new Date(gameData.startTimestamp).toLocaleDateString().trim(),
          teamName: teamDetails.code.trim(),
          patch: gameData.patchVersion.trim(),
          duration: gameData.gameDuration,
          won: teamDetails.towers > opponentDetails.towers,
          towers: teamDetails.towers,
          gold: teamDetails.gold,
          kills: teamDetails.kills,
          teamGameDetail: teamDetails,
          opponentGameDetail: opponentDetails,
          redSidePlayers,
          blueSidePlayers,
          redSide: redSide,
          blueSide: blueSide
        };
      }).filter(game => game);
    },
    mapTeamGameDetails(item) {
      return [
        {
          teamName: item.teamGameDetail.code.trim(),
          towers: item.teamGameDetail.towers,
          gold: item.teamGameDetail.gold,
          kills: item.teamGameDetail.kills,
          won: item.won,
          drakes: item.teamGameDetail.dragons.join().trim(),
        },
        {
          teamName: item.opponentGameDetail.code.trim(),
          towers: item.opponentGameDetail.towers,
          gold: item.opponentGameDetail.gold,
          kills: item.opponentGameDetail.kills,
          won: !item.won,
          drakes: item.opponentGameDetail.dragons.join().trim(),
        },
      ];
    },
    async fetchTeams(filters) {
      const { result, error, loading } = provideApolloClient(apolloClient)(() => useQuery(GET_GAMES_BY_TEAM_EXTERNAL_ID, filters));
      if (error.value) {
        console.error('Error fetching team data:', error.value);
        return;
      }
      await new Promise(resolve => setTimeout(resolve, 500));
      const games = computed(() => result.value?.gameDataByTeamId);
      if (!games.value) {
        console.warn('No games found for the given team externalId:', filters.externalId);
        return [];
      }
      return {
        games,
        loading,
      };
    },
    async searchHomeTeam(val) {
      this.homeLoading = true;
      const { games, loading } = await this.fetchTeams({ externalId: val });
      watchEffect(() => {
        if (!games) {
          return;
        }
        const gameMap = this.mapTeamGames(games?.value, val);
        this.homeMatches = gameMap || [];
        this.homeLoading = loading?.value;
      });
    },
    async searchAwayTeam(val) {
      this.awayLoading = true;
      const { games, loading } = await this.fetchTeams({ externalId: val });
      watchEffect(() => {
        if (!games) {
          return;
        }
        const gameMap = this.mapTeamGames(games?.value, val);
        this.awayMatches = gameMap || [];
        this.awayLoading = loading?.value;
      });
    },
    async filterByChampion(championId) {
      if (!championId) {
        // If no champion is selected, reset to all matches
        if (this.selectedHomeTeam) {
          await this.searchHomeTeam(this.selectedHomeTeam);
        }
        return;
      }
      const filterMatches = (matches) => matches.filter(match =>
        match.redSideChampions.some(champ => champ.name === championId) ||
        match.blueSideChampions.some(champ => champ.name === championId)
      );
      if (this.selectedHomeTeam) {
        this.homeMatches = filterMatches(this.homeMatches);
      }
      if (this.selectedAwayTeam) {
        this.awayMatches = filterMatches(this.awayMatches);
      }
    },
  },
};
</script>

<style scoped>
.v-data-table {
  width: 100% !important;
  border: 1px solid #424242 !important; /* Dark mode border */
  background-color: #212121 !important; /* Dark background */
  table-layout: fixed !important; /* Ensure columns align with content */
}
.v-data-table-header {
  background-color: #0288d1 !important; /* Lighter blue for dark mode */
  color: #ffffff !important; /* White text for contrast */
  font-weight: 600;
}
.v-data-table-header th {
  font-size: 14px !important; /* Match cell font size */
  padding: 8px !important; /* Consistent padding with cells */
  height: 48px !important; /* Adjust height to match row content */
  border-bottom: 2px solid #616161 !important; /* Subtle border */
  white-space: nowrap !important; /* Prevent wrapping, remove white spaces */
  text-align: left !important; /* Align text consistently */
  overflow: hidden !important; /* Prevent overflow causing misalignment */
  text-overflow: ellipsis !important; /* Handle long text gracefully */
}
.v-data-table__tr {
  background-color: #303030 !important; /* Dark row background */
}
.v-data-table__tr:nth-child(even) {
  background-color: #424242 !important; /* Slightly lighter for alternating rows */
}
.v-data-table__td {
  padding: 8px !important; /* Match header padding */
  font-size: 14px !important; /* Match header font size */
  color: #e0e0e0 !important; /* Light text for readability */
  white-space: nowrap !important; /* Prevent wrapping, remove white spaces */
  overflow: hidden !important; /* Prevent overflow */
  text-overflow: ellipsis !important; /* Handle long text */
}
.v-tabs {
  margin-bottom: 16px;
  background-color: #212121 !important; /* Match dark theme */
}
.v-tab {
  color: #e0e0e0 !important; /* Light text for tabs */
}
.v-tab--active {
  background-color: #0288d1 !important; /* Highlight active tab */
  color: #ffffff !important;
}
.v-window {
  background-color: #212121 !important; /* Dark background for tab content */
}
.v-card-title {
  color: #e0e0e0 !important; /* Light text for card titles */
}
.v-container {
  background-color: #212121 !important; /* Dark background for expanded content */
}
.green--text {
  color: #4caf50 !important; /* Green for positive gold diff */
}
.red--text {
  color: #ef5350 !important; /* Red for negative or zero gold diff */
}
</style>
