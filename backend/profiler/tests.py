from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase
from .models import UserProfile


class UserProfileTests(APITestCase):

    def setUp(self):
        self.user_profile_data = {
            "first_name": "Big",
            "last_name": "Smoke",
            "email": "big.smoke@example.com",
            "username": "MrChesse"
        }
        self.create_url = reverse('userprofile-list')
        self.user_profile = UserProfile.objects.create(
            **self.user_profile_data)

        self.another_user_profile_data = {
            "first_name": "Carl",
            "last_name": "Johnson",
            "email": "carl.johnson@example.com",
            "username": "CarlJohn"
        }
        self.another_user_profile = UserProfile.objects.create(
            **self.another_user_profile_data)

    def test_create_user_profile(self):
        new_user_profile_data = {
            "first_name": "Mike",
            "last_name": "Wazowski",
            "email": "mike.wazowski@example.com",
            "username": "MikeWazowski"
        }
        response = self.client.post(
            self.create_url, new_user_profile_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(UserProfile.objects.count(), 3)
        self.assertEqual(UserProfile.objects.get(
            username="MikeWazowski").first_name, "Mike")

    def test_list_user_profiles(self):
        response = self.client.get(self.create_url, {'limit': 10, 'offset': 0})
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data['results']), 2)
        self.assertEqual(response.data['count'], 2)

    def test_search_user_profiles_by_username(self):
        response = self.client.get(self.create_url, {'q': 'CarlJohn'})
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data['results']), 1)

    def test_search_user_profiles_by_first_name(self):
        response = self.client.get(self.create_url, {'q': 'Big'})
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data['results']), 1)

    def test_search_user_profiles_by_last_name(self):
        response = self.client.get(self.create_url, {'q': 'Smoke'})
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data['results']), 1)

    def test_search_user_profiles_by_email(self):
        response = self.client.get(self.create_url, {'q': 'example.com'})
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data['results']), 2)

    def test_update_user_profile(self):
        update_url = reverse('userprofile-detail',
                             args=[self.another_user_profile.id])
        update_data = {
            "first_name": "Carl",
            "last_name": "Johnson",
            "email": "carl.j@example.com",
            "username": "CarlJohn"
        }
        response = self.client.put(update_url, update_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.another_user_profile.refresh_from_db()
        self.assertEqual(self.another_user_profile.first_name, "Carl")

    def test_delete_user_profile(self):
        # Delete the other profile
        delete_url = reverse('userprofile-detail',
                             args=[self.another_user_profile.id])
        response = self.client.delete(delete_url)
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        self.assertEqual(UserProfile.objects.count(), 1)
