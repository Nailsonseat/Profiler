from rest_framework import viewsets, status
from ..models import UserProfile
from django.db.models import Q
from ..serializations.userProfile import UserProfileSerializer
from rest_framework.response import Response
from rest_framework.response import Response


class UserProfileViewSet(viewsets.ModelViewSet):
    queryset = UserProfile.objects.all()
    serializer_class = UserProfileSerializer

    def list(self, request):
        limit = request.query_params.get('limit', None)
        offset = request.query_params.get('offset', 0)
        query = request.query_params.get('q', None)

        try:
            if limit is not None:
                limit = int(limit)
            offset = int(offset)
        except ValueError:
            return Response({"error": "limit and offset should be integers."}, status=status.HTTP_400_BAD_REQUEST)

        if query:
            queryset = UserProfile.objects.filter(
                Q(username__icontains=query) |
                Q(first_name__icontains=query) |
                Q(last_name__icontains=query) |
                Q(email__icontains=query)
            )
        else:
            queryset = UserProfile.objects.all()

        paginated_queryset = queryset[offset:offset +
                                      limit] if limit else queryset[offset:]
        serializer = UserProfileSerializer(paginated_queryset, many=True)

        return Response({
            'count': queryset.count(),
            'limit': limit,
            'offset': offset,
            'results': serializer.data
        })
