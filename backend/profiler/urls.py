from rest_framework.routers import DefaultRouter
from django.urls import path, include
from .views.chatBot import ChatBotAPIView
from .views.userProfile import UserProfileViewSet

router = DefaultRouter()
router.register(r'profiles', UserProfileViewSet)

urlpatterns = [
    path('', include(router.urls)),
    path('chatbot/', ChatBotAPIView.as_view()),
]
