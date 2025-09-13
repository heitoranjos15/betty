<template>
  <v-app>
    <v-main>
      <v-container fluid>
        <v-row>
          <!-- Home Team -->
          <v-col cols="12" md="6">
            <v-card class="mb-4" flat>
              <v-card-title class="text-h5 font-weight-bold">
                Home Team Matches
                <v-spacer></v-spacer>
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
              </v-card-title>
              <v-card-text>
                <v-data-table
                  :headers="headers"
                  :items="homeMatches"
                  item-key="id"
                  class="elevation-1"
                  hide-default-footer
                  dense
                  fixed-header
                  height="400px"
                  :loading="homeLoading"
                  show-header
                  :expanded="expandedHome"
                  show-expand
                  style="width: 100%;"
                >
<template #item="{ item }">
  <v-chip :color="item.won ? 'green darken-2' : 'red darken-2'" dark small>
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
                            <v-window-item value="team-details">
                              <!-- Team Details Table -->
                              <v-card flat class="mt-4">
                                <v-card-title>Team Statistics</v-card-title>
                                <v-data-table
                                  :headers="teamHeaders"
                                  :items="getTeamDetails(item)"
                                  item-key="teamName"
                                  class="elevation-1"
                                  hide-default-footer
                                  dense
                                  style="width: 100%;"
                                ></v-data-table>
                              </v-card>
                              <!-- Player Tables (Side by Side) -->
                              <v-row class="mt-4">
                                <v-col cols="12" md="6">
                                  <v-card flat>
                                    <v-card-title>{{ item.teamName }} Players</v-card-title>
                                    <v-data-table
                                      :headers="playerHeaders"
                                      :items="item.players.filter(p => p.teamId === selectedHomeTeam)"
                                      item-key="name"
                                      class="elevation-1"
                                      hide-default-footer
                                      dense
                                      style="width: 100%;"
                                    ></v-data-table>
                                  </v-card>
                                </v-col>
                                <v-col cols="12" md="6">
                                  <v-card flat>
                                    <v-card-title>{{ item.opponent }} Players</v-card-title>
                                    <v-data-table
                                      :headers="playerHeaders"
                                      :items="item.players.filter(p => p.teamId !== selectedHomeTeam)"
                                      item-key="name"
                                      class="elevation-1"
                                      hide-default-footer
                                      dense
                                      style="width: 100%;"
                                    ></v-data-table>
                                  </v-card>
                                  </v-col>
                                </v-row>
                              </v-window-item>
                            </v-window>
<!-- Removed invalid </v-tabs> closing tag -->
                        </v-container>
                      </td>
                    </tr>
                  </template>
                </v-data-table>
              </v-card-text>
            </v-card>
          </v-col>
          <!-- Away Team -->
          <v-col cols="12" md="6">
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
                  hide-default-footer
                  dense
                  fixed-header
                  height="400px"
                  :loading="awayLoading"
                  show-header
                  :expanded="expandedAway"
                  show-expand
                  style="width: 100%;"
                >
                
                  <!-- eslint-disable-next-line vue/valid-v-slot -->
                  <template #item.won="{ item }">
                    <v-chip :color="item.won ? 'green darken-2' : 'red darken-2'" dark small>
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
                            <v-window-item value="team-details">
                              <!-- Team Details Table -->
                              <v-card flat class="mt-4">
                                <v-card-title>Team Statistics</v-card-title>
                                <v-data-table
                                  :headers="teamHeaders"
                                  :items="getTeamDetails(item)"
                                  item-key="teamName"
                                  class="elevation-1"
                                  hide-default-footer
                                  dense
                                  style="width: 100%;"
                                ></v-data-table>
                              </v-card>
                              <!-- Player Tables (Side by Side) -->
                              <v-row class="mt-4">
                                <v-col cols="12" md="6">
                                  <v-card flat>
                                    <v-card-title>{{ item.teamName }} Players</v-card-title>
                                    <v-data-table
                                      :headers="playerHeaders"
                                      :items="item.players.filter(p => p.teamId === selectedAwayTeam)"
                                      item-key="name"
                                      class="elevation-1"
                                      hide-default-footer
                                      dense
                                      style="width: 100%;"
                                    ></v-data-table>
                                  </v-card>
                                </v-col>
                                <v-col cols="12" md="6">
                                  <v-card flat>
                                    <v-card-title>{{ item.opponent }} Players</v-card-title>
                                    <v-data-table
                                      :headers="playerHeaders"
                                      :items="item.players.filter(p => p.teamId !== selectedAwayTeam)"
                                      item-key="name"
                                      class="elevation-1"
                                      hide-default-footer
                                      dense
                                      style="width: 100%;"
                                    ></v-data-table>
                                  </v-card>
                                  </v-col>
                                </v-row>
                              </v-window-item>
                            </v-window>
<!-- Removed invalid </v-tabs> closing tag -->
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
export default {
  name: 'App',
  setup() {
    const teamOptions = [
      { name: 'Team Alpha', externalId: 'team1' },
      { name: 'Team Beta', externalId: 'team2' },
      { name: 'Team Gamma', externalId: 'team3' },
    ];

    return { teamOptions };
  },
  data() {
    return {
      headers: [
        { title: 'Opponent', key: 'opponent', sortable: true },
        { title: 'Patch', key: 'patch', sortable: true },
        { title: 'Duration', key: 'duration', sortable: true },
        { title: 'Towers', key: 'towers', sortable: true },
        { title: 'Gold', key: 'gold', sortable: true },
        { title: 'Kills', key: 'kills', sortable: true },
        { title: 'Won', key: 'won', sortable: true },
      ],
      teamHeaders: [
        { title: 'Team', key: 'teamName', sortable: true },
        { title: 'Kills', key: 'kills', sortable: true },
        { title: 'Gold', key: 'gold', sortable: true },
        { title: 'Towers', key: 'towers', sortable: true },
        { title: 'Drakes', key: 'drakes', sortable: true },
      ],
      playerHeaders: [
        { title: 'Player Name', key: 'name', sortable: true },
        { title: 'Kills', key: 'kills', sortable: true },
        { title: 'Gold', key: 'gold', sortable: true },
      ],
      homeMatches: [],
      awayMatches: [],
      selectedHomeTeam: null,
      selectedAwayTeam: null,
      homeLoading: false,
      awayLoading: false,
      expandedHome: [],
      expandedAway: [],
      activeTab: 'team-details',
      mockMatches: [
        {
          id: 'game1',
          teamName: 'Team Alpha',
          opponent: 'Team Beta',
          patch: '14.1',
          duration: 1800,
          won: true,
          towers: 7,
          gold: 50000,
          kills: 20,
          drakes: 2,
          opponentKills: 15,
          opponentGold: 45000,
          opponentTowers: 4,
          opponentDrakes: 1,
          players: [
            { name: 'Player1', kills: 5, gold: 12000, teamId: 'team1' },
            { name: 'Player2', kills: 4, gold: 11000, teamId: 'team1' },
            { name: 'Player3', kills: 3, gold: 10000, teamId: 'team1' },
            { name: 'Player4', kills: 6, gold: 13000, teamId: 'team1' },
            { name: 'Player5', kills: 2, gold: 9000, teamId: 'team1' },
            { name: 'Player6', kills: 3, gold: 10000, teamId: 'team2' },
            { name: 'Player7', kills: 4, gold: 11000, teamId: 'team2' },
            { name: 'Player8', kills: 2, gold: 9000, teamId: 'team2' },
            { name: 'Player9', kills: 5, gold: 12000, teamId: 'team2' },
            { name: 'Player10', kills: 1, gold: 8000, teamId: 'team2' },
          ],
        },
        {
          id: 'game1',
          teamName: 'Team Alpha',
          opponent: 'Team Beta',
          patch: '14.1',
          duration: 1800,
          won: true,
          towers: 7,
          gold: 50000,
          kills: 20,
          drakes: 2,
          opponentKills: 15,
          opponentGold: 45000,
          opponentTowers: 4,
          opponentDrakes: 1,
          players: [
            { name: 'Player1', kills: 5, gold: 12000, teamId: 'team1' },
            { name: 'Player2', kills: 4, gold: 11000, teamId: 'team1' },
            { name: 'Player3', kills: 3, gold: 10000, teamId: 'team1' },
            { name: 'Player4', kills: 6, gold: 13000, teamId: 'team1' },
            { name: 'Player5', kills: 2, gold: 9000, teamId: 'team1' },
            { name: 'Player6', kills: 3, gold: 10000, teamId: 'team2' },
            { name: 'Player7', kills: 4, gold: 11000, teamId: 'team2' },
            { name: 'Player8', kills: 2, gold: 9000, teamId: 'team2' },
            { name: 'Player9', kills: 5, gold: 12000, teamId: 'team2' },
            { name: 'Player10', kills: 1, gold: 8000, teamId: 'team2' },
          ],
        },
        {
          id: 'game2',
          teamName: 'Team Gamma',
          opponent: 'Team Alpha',
          patch: '14.2',
          duration: 2000,
          won: false,
          towers: 3,
          gold: 40000,
          kills: 12,
          drakes: 1,
          opponentKills: 18,
          opponentGold: 48000,
          opponentTowers: 6,
          opponentDrakes: 2,
          players: [
            { name: 'Player11', kills: 3, gold: 10000, teamId: 'team3' },
            { name: 'Player12', kills: 2, gold: 9000, teamId: 'team3' },
            { name: 'Player13', kills: 4, gold: 11000, teamId: 'team3' },
            { name: 'Player14', kills: 1, gold: 8000, teamId: 'team3' },
            { name: 'Player15', kills: 2, gold: 9000, teamId: 'team3' },
            { name: 'Player1', kills: 5, gold: 12000, teamId: 'team1' },
            { name: 'Player2', kills: 4, gold: 11000, teamId: 'team1' },
            { name: 'Player3', kills: 3, gold: 10000, teamId: 'team1' },
            { name: 'Player4', kills: 6, gold: 13000, teamId: 'team1' },
            { name: 'Player5', kills: 2, gold: 9000, teamId: 'team1' },
          ],
        },
      ],
    };
  },
  methods: {
    getTeamDetails(item) {
      return [
        {
          teamName: item.teamName,
          kills: item.kills,
          gold: item.gold,
          towers: item.towers,
          drakes: item.drakes,
        },
        {
          teamName: item.opponent,
          kills: item.opponentKills,
          gold: item.opponentGold,
          towers: item.opponentTowers,
          drakes: item.opponentDrakes,
        },
      ];
    },
    searchHomeTeam(val) {
      this.homeLoading = true;
      setTimeout(() => {
        this.homeMatches = this.mockMatches.filter(
          match => match.teamName === this.teamOptions.find(team => team.externalId === val)?.name
        );
        this.homeLoading = false;
      }, 500);
    },
    searchAwayTeam(val) {
      this.awayLoading = true;
      setTimeout(() => {
        this.awayMatches = this.mockMatches.filter(
          match => match.teamName === this.teamOptions.find(team => team.externalId === val)?.name
        );
        this.awayLoading = false;
      }, 500);
    },
  },
};
</script>

<style scoped>
.v-data-table {
  width: 100% !important;
  border: 1px solid #424242 !important; /* Dark mode border */
  background-color: #212121 !important; /* Dark background */
}
.v-data-table-header {
  background-color: #0288d1 !important; /* Lighter blue for dark mode */
  color: #ffffff !important; /* White text for contrast */
  font-weight: 600;
}
.v-data-table-header th {
  font-size: 15px !important;
  padding: 12px !important;
  height: 56px !important;
  border-bottom: 2px solid #616161 !important; /* Subtle border */
}
.v-data-table__tr {
  background-color: #303030 !important; /* Dark row background */
}
.v-data-table__tr:nth-child(even) {
  background-color: #424242 !important; /* Slightly lighter for alternating rows */
}
.v-data-table__td {
  padding: 8px !important;
  font-size: 14px;
  color: #e0e0e0 !important; /* Light text for readability */
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
</style>
